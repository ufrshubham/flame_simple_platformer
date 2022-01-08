import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'level/level.dart';

// Represents the game world
class SimplePlatformer extends FlameGame {
  // Currently active level
  Level? _currentLevel;

  @override
  Future<void>? onLoad() async {
    // Device setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

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
