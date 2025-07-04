import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_simple_platformer/game/actors/player.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';
import 'package:flutter/material.dart';

// Represents a door in the game world.
class Door extends SpriteComponent with CollisionCallbacks {
  VoidCallback? onPlayerEnter;

  Door(
    super.image, {
    this.onPlayerEnter,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  }) : super.fromImage(
          srcPosition: Vector2(2 * 32, 0),
          srcSize: Vector2.all(32),
        );

  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) {
      AudioManager.playSfx('Blop_1.wav');
      onPlayerEnter?.call();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
