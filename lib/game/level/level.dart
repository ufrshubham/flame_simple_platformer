import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame_simple_platformer/game/actors/coin.dart';
import 'package:flame_simple_platformer/game/actors/door.dart';
import 'package:flame_simple_platformer/game/actors/enemy.dart';
import 'package:flame_simple_platformer/game/actors/platform.dart';
import 'package:flame_simple_platformer/game/actors/player.dart';
import 'package:flame_simple_platformer/game/game.dart';
import 'package:flame_simple_platformer/game/game_play.dart';
import 'package:flame_tiled/flame_tiled.dart';

// Represents a level in game. Should only be added as child of GamePlay
class Level extends Component
    with HasGameReference<SimplePlatformer>, ParentIsA<GamePlay> {
  final String levelName;
  late Player _player;

  Level(this.levelName) : super();

  @override
  Future<void> onLoad() async {
    final level = await TiledComponent.load(
      levelName,
      Vector2.all(32),
    );
    await add(level);

    _spawnActors(level);
    _setupCamera(level);
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors(TiledComponent level) {
    final tileMap = level.tileMap;
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
      final position = Vector2(spawnPoint.x, spawnPoint.y - spawnPoint.height);
      final size = Vector2(spawnPoint.width, spawnPoint.height);

      switch (spawnPoint.class_) {
        case 'Player':
          final halfSize = size * 0.5;
          final levelBounds = Rect.fromLTWH(
            halfSize.x,
            halfSize.y,
            level.size.x - halfSize.x,
            level.size.y - halfSize.y,
          );

          _player = Player(
            game.spriteSheet,
            anchor: Anchor.center,
            position: position,
            size: size,
            children: [
              BoundedPositionBehavior(
                bounds: Rectangle.fromRect(levelBounds),
              ),
            ],
          );
          add(_player);

          break;

        case 'Coin':
          final coin = Coin(
            game.spriteSheet,
            position: position,
            size: size,
          );
          add(coin);

          break;

        case 'Enemy':
          // Find the target object.
          final targetObjectId =
              int.parse(spawnPoint.properties.first.value.toString());
          final target = spawnPointsLayer.objects
              .firstWhere((object) => object.id == targetObjectId);

          final enemy = Enemy(
            game.spriteSheet,
            position: position,
            targetPosition: Vector2(target.x, target.y),
            size: size,
          );
          add(enemy);

          break;

        case 'Door':
          final door = Door(
            game.spriteSheet,
            position: position,
            size: size,
            onPlayerEnter: () {
              parent.loadLevel(spawnPoint.properties.first.value.toString());
            },
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
  void _setupCamera(TiledComponent level) {
    parent.camera.follow(_player, maxSpeed: 200);
    parent.camera.setBounds(
      Rectangle.fromLTRB(
        game.fixedResolution.x / 2,
        game.fixedResolution.y / 2,
        level.width - game.fixedResolution.x / 2,
        level.height - game.fixedResolution.y / 2,
      ),
    );
  }
}
