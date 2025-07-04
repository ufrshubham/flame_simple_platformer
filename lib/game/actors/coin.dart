import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_simple_platformer/game/actors/player.dart';
import 'package:flame_simple_platformer/game/game.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';
import 'package:flutter/animation.dart';

// Represents a collectable coin in the game world.
class Coin extends SpriteComponent
    with CollisionCallbacks, HasGameReference<SimplePlatformer> {
  Coin(
    super.image, {
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  }) : super.fromImage(
          srcPosition: Vector2(3 * 32, 0),
          srcSize: Vector2.all(32),
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox()..collisionType = CollisionType.passive);

    // Keeps the coin bouncing
    await add(
      MoveEffect.by(
        Vector2(0, -4),
        EffectController(
          alternate: true,
          infinite: true,
          duration: 1,
          curve: Curves.ease,
        ),
      ),
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) {
      AudioManager.playSfx('Collectibles_6.wav');

      // SequenceEffect can also be used here
      add(
        OpacityEffect.fadeOut(
          LinearEffectController(0.3),
          onComplete: () {
            add(RemoveEffect());
          },
        ),
      );

      game.playerData.score.value += 1;
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
