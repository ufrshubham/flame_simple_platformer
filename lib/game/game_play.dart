import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';

import 'game.dart';
import 'hud/hud.dart';
import 'level/level.dart';
import 'touch_controls.dart';

// This component is responsible for the whole game play.
class GamePlay extends World with HasGameReference<SimplePlatformer> {
  // Currently active level
  Level? _currentLevel;

  final hud = Hud(priority: 1);
  late CameraComponent camera;

  // On-screen controls.
  final touchControls = TouchControls(position: Vector2.zero());

  @override
  Future<void> onLoad() async {
    AudioManager.playBgm('Winning_Sight.wav');

    camera = CameraComponent.withFixedResolution(
      world: this,
      width: game.fixedResolution.x,
      height: game.fixedResolution.y,
      hudComponents: [hud, touchControls],
    );
    camera.viewfinder.position = game.fixedResolution / 2;
    await game.add(camera);

    loadLevel('Level1.tmx');
    game.playerData.score.value = 0;
    game.playerData.health.value = 5;
  }

  // Swaps current level with given level
  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }
}
