import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

// Represents a platform in the game world.
class Platform extends PositionComponent with CollisionCallbacks {
  Platform({
    required Vector2 position,
    required Vector2 size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
        );

  @override
  Future<void> onLoad() async {
    // Passive, because we don't want platforms to
    // collide with each other.
    await add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}
