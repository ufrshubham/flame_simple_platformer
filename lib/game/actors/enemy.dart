import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_simple_platformer/game/actors/player.dart';

// Represents an enemy in the game world.
class Enemy extends SpriteComponent with CollisionCallbacks {
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
          )..onFinishCallback = () => flipHorizontallyAroundCenter(),
          MoveToEffect(
            position + Vector2(32, 0), // Need to offset by 32 due to flip
            EffectController(speed: 100),
          )..onFinishCallback = () => flipHorizontallyAroundCenter(),
        ],
        infinite: true,
      );

      add(effect);
    }
  }

  @override
  Future<void>? onLoad() {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      other.hit();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
