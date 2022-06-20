import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_simple_platformer/game/hud/hud.dart';
import 'package:flame_simple_platformer/game/model/player_data.dart';

import 'level/level.dart';
import 'touch_controls.dart';

// Represents the game world
class SimplePlatformer extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasTappables {
  // Currently active level
  Level? _currentLevel;

  // On-screen controls.
  late TouchControls touchControls;

  // Reference to common spritesheet
  late Image spriteSheet;

  final playerData = PlayerData();

  @override
  Future<void>? onLoad() async {
    // Device setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    spriteSheet = await images.load('Spritesheet.png');

    camera.viewport = FixedResolutionViewport(
      Vector2(640, 330),
    );

    // Add on-screen controls.
    touchControls = TouchControls(position: Vector2.zero(), priority: 1);
    add(touchControls);

    loadLevel('Level1.tmx');

    add(Hud(priority: 1));

    return super.onLoad();
  }

  // Swaps current level with given level
  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }
}
