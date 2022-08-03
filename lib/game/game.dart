import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';

import 'model/player_data.dart';
import 'touch_controls.dart';

// Represents the game world
class SimplePlatformer extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasTappables {
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

    // Loads all the audio assets
    await AudioManager.init();

    spriteSheet = await images.load('Spritesheet.png');

    camera.viewport = FixedResolutionViewport(
      Vector2(640, 330),
    );

    // Add on-screen controls.
    touchControls = TouchControls(position: Vector2.zero(), priority: 1);
    add(touchControls);

    return super.onLoad();
  }
}
