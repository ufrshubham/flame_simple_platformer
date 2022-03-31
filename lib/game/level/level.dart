import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';

import '../game.dart';
import '../actors/coin.dart';
import '../actors/door.dart';
import '../actors/enemy.dart';
import '../actors/player.dart';
import '../actors/platform.dart';

// Represents a level in game.
class Level extends Component with HasGameRef<SimplePlatformer> {
  final String levelName;
  late Player _player;
  late Rect _levelBounds;

  Level(this.levelName) : super();

  @override
  Future<void>? onLoad() async {
    final level = await TiledComponent.load(
      levelName,
      Vector2.all(32),
    );
    add(level);

    _levelBounds = Rect.fromLTWH(
      0,
      0,
      (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble(),
      (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble(),
    );

    _spawnActors(level.tileMap);
    _setupCamera();

    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors(RenderableTiledMap tileMap) {
    final platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');

    for (final platformObject in platformsLayer!.objects) {
      final platform = Platform(
        position: Vector2(platformObject.x, platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }

    final spawnPointsLayer = tileMap.getLayer<ObjectGroup>('SpawnPoints');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.type) {
        case 'Player':
          _player = Player(
            gameRef.spriteSheet,
            anchor: Anchor.center,
            levelBounds: _levelBounds,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(_player);

          break;

        case 'Coin':
          final coin = Coin(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(coin);

          break;

        case 'Enemy':
          final enemy = Enemy(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(enemy);

          break;

        case 'Door':
          final door = Door(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(door);

          break;
      }
    }
  }

  // This method is responsible for making the camera
  // follow the player component and also for keeping
  // the camera within level bounds.
  /// NOTE: Call only after [_spawnActors].
  void _setupCamera() {
    gameRef.camera.followComponent(_player);
    gameRef.camera.worldBounds = _levelBounds;
  }
}
