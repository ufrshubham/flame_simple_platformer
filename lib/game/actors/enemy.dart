import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';

import '../game.dart';
import 'player.dart';

// Represents an enemy in the game world.
class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SimplePlatformer> {
  static final Vector2 _up = Vector2(0, -1);

  Enemy(
    Image image, {
    Vector2? position,
    Vector2? targetPosition,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(
          image,
          srcPosition: Vector2(1 * 32, 0),
          srcSize: Vector2.all(32),
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    if (targetPosition != null && position != null) {
      // Need to sequence two move to effects so that we can
      // tap into the onFinishCallback and flip the component.
      final effect = SequenceEffect(
        [
          MoveToEffect(
            targetPosition,
            EffectController(speed: 100),
            onComplete: () => flipHorizontallyAroundCenter(),
          ),
          MoveToEffect(
            position + Vector2(32, 0), // Need to offset by 32 due to flip
            EffectController(speed: 100),
            onComplete: () => flipHorizontallyAroundCenter(),
          ),
        ],
        infinite: true,
      );

      add(effect);
    }
  }

  @override
  Future<void> onLoad() async {
    await add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      final playerDir = (other.absoluteCenter - absoluteCenter).normalized();

      // Checks if player is hitting this enemy from the top.
      if (playerDir.dot(_up) > 0.85) {
        // Fade out and remove this enemy and make the player auto-jump.
        add(
          OpacityEffect.fadeOut(
            LinearEffectController(0.2),
            onComplete: () => removeFromParent(),
          ),
        );
        other.airHop();
      } else {
        AudioManager.playSfx('Hit_2.wav');
        // Run hit effect on player and reduce the health.
        other.hit();
        if (gameRef.playerData.health.value > 0) {
          gameRef.playerData.health.value -= 1;
        }
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
