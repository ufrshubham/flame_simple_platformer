import 'package:flame/components.dart';
import 'package:flame_simple_platformer/game/game.dart';

class Hud extends Component with HasGameRef<SimplePlatformer> {
  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  Future<void>? onLoad() {
    final scoreTextComponent = TextComponent(
      text: 'Score: 0',
      position: Vector2.all(10),
    );
    add(scoreTextComponent);

    final healthTextComponent = TextComponent(
      text: 'x5',
      anchor: Anchor.topRight,
      position: Vector2(gameRef.size.x - 10, 10),
    );
    add(healthTextComponent);

    final playerSprite = SpriteComponent.fromImage(
      gameRef.spriteSheet,
      srcPosition: Vector2.zero(),
      srcSize: Vector2.all(32),
      anchor: Anchor.topRight,
      position: Vector2(
          healthTextComponent.position.x - healthTextComponent.size.x - 5, 5),
    );
    add(playerSprite);

    gameRef.playerData.score.addListener(() {
      scoreTextComponent.text = 'Score: ${gameRef.playerData.score.value}';
    });

    gameRef.playerData.health.addListener(() {
      healthTextComponent.text = 'x${gameRef.playerData.health.value}';
    });

    return super.onLoad();
  }
}
