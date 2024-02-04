import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

// Represents a platform in the game world.
class Platform extends PositionComponent with CollisionCallbacks {
  Platform({
    required Vector2 super.position,
    required Vector2 super.size,
    super.scale,
    super.angle,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // Passive, because we don't want platforms to
    // collide with each other.
    await add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}
