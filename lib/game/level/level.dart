import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../game.dart';
import '../actors/coin.dart';
import '../actors/door.dart';
import '../actors/enemy.dart';
import '../actors/player.dart';
import '../actors/platform.dart';

// Represents a level in game.
class Level extends Component with HasGameRef<SimplePlatformer> {
  final String levelName;

  Level(this.levelName) : super();

  @override
  Future<void>? onLoad() async {
    final level = await TiledComponent.load(
      levelName,
      Vector2.all(32),
    );
    add(level);

    _spawnActors(level.tileMap);

    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors(RenderableTiledMap tileMap) {
    final platformsLayer = tileMap.getObjectGroupFromLayer('Platforms');

    for (final platformObject in platformsLayer.objects) {
      final platform = Platform(
        position: Vector2(platformObject.x, platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }

    final spawnPointsLayer = tileMap.getObjectGroupFromLayer('SpawnPoints');

    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.type) {
        case 'Player':
          final player = Player(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(player);

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
}
