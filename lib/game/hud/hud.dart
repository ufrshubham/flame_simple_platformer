import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'package:flame_simple_platformer/game/game.dart';
import 'package:flame_simple_platformer/game/overlays/game_over.dart';
import 'package:flame_simple_platformer/game/overlays/pause_menu.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';

class Hud extends Component with HasGameReference<SimplePlatformer> {
  late final TextComponent scoreTextComponent;
  late final TextComponent healthTextComponent;

  Hud({super.children, super.priority});

  @override
  Future<void> onLoad() async {
    scoreTextComponent = TextComponent(
      text: 'Score: 0',
      position: Vector2.all(10),
    );
    await add(scoreTextComponent);

    healthTextComponent = TextComponent(
      text: 'x5',
      anchor: Anchor.topRight,
      position: Vector2(game.fixedResolution.x - 10, 10),
    );
    await add(healthTextComponent);

    final playerSprite = SpriteComponent.fromImage(
      game.spriteSheet,
      srcPosition: Vector2.zero(),
      srcSize: Vector2.all(32),
      anchor: Anchor.topRight,
      position: Vector2(
        healthTextComponent.position.x - healthTextComponent.size.x - 5,
        5,
      ),
    );
    await add(playerSprite);

    game.playerData.score.addListener(onScoreChange);
    game.playerData.health.addListener(onHealthChange);

    final pauseButton = SpriteButtonComponent(
      onPressed: () {
        AudioManager.pauseBgm();
        game.pauseEngine();
        game.overlays.add(PauseMenu.id);
      },
      button: Sprite(
        game.spriteSheet,
        srcSize: Vector2.all(32),
        srcPosition: Vector2(32 * 4, 0),
      ),
      size: Vector2.all(32),
      anchor: Anchor.topCenter,
      position: Vector2(game.fixedResolution.x / 2, 5),
    );
    await add(pauseButton);
  }

  @override
  void onRemove() {
    game.playerData.score.removeListener(onScoreChange);
    game.playerData.health.removeListener(onHealthChange);
    super.onRemove();
  }

  // Updates score text on hud.
  void onScoreChange() {
    scoreTextComponent.text = 'Score: ${game.playerData.score.value}';
  }

  // Updates health text on hud.
  void onHealthChange() {
    healthTextComponent.text = 'x${game.playerData.health.value}';

    // Load game over overlay if health is zero.
    if (game.playerData.health.value == 0) {
      AudioManager.stopBgm();
      game.pauseEngine();
      game.overlays.add(GameOver.id);
    }
  }
}
