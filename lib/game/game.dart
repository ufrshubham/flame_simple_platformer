import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_simple_platformer/game/model/player_data.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';

// Represents the game world
class SimplePlatformer extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // Reference to common spritesheet
  late Image spriteSheet;

  final playerData = PlayerData();
  final fixedResolution = Vector2(640, 330);

  @override
  Future<void> onLoad() async {
    // Device setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    // Loads all the audio assets
    await AudioManager.init();
    spriteSheet = await images.load('Spritesheet.png');
  }
}
