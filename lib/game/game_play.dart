import 'package:flame/components.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';

import 'game.dart';
import 'hud/hud.dart';
import 'level/level.dart';

// This component is responsible for the whole game play.
class GamePlay extends Component with HasGameRef<SimplePlatformer> {
  // Currently active level
  Level? _currentLevel;

  final hud = Hud(priority: 1);

  @override
  Future<void>? onLoad() {
    AudioManager.playBgm('Winning_Sight.wav');

    loadLevel('Level1.tmx');
    gameRef.add(hud);
    gameRef.playerData.score.value = 0;
    gameRef.playerData.health.value = 5;

    return super.onLoad();
  }

  @override
  void onRemove() {
    gameRef.remove(hud);
    super.onRemove();
  }

  // Swaps current level with given level
  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }
}
