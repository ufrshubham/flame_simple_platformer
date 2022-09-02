import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';

import 'model/player_data.dart';

// Represents the game world
class SimplePlatformer extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasTappables {
  // Reference to common spritesheet
  late Image spriteSheet;

  final playerData = PlayerData();

  final world = World();
  late final worldCam =
      CameraComponent(world: world, viewport: FixedSizeViewport(640, 330));

  @override
  Future<void>? onLoad() async {
    // Device setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    // Loads all the audio assets
    await AudioManager.init();

    spriteSheet = await images.load('Spritesheet.png');

    add(world);
    add(worldCam);

    return super.onLoad();
  }
}
