import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';

import 'level/level.dart';

// Represents the game world
class SimplePlatformer extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // Currently active level
  Level? _currentLevel;

  // Reference to common spritesheet
  late Image spriteSheet;

  @override
  Future<void>? onLoad() async {
    // Device setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    spriteSheet = await images.load('Spritesheet.png');

    camera.viewport = FixedResolutionViewport(
      Vector2(640, 330),
    );

    loadLevel('Level1.tmx');

    return super.onLoad();
  }

  // Swaps current level with given level
  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }
}
