import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_simple_platformer/game/game_play.dart';
import 'package:flutter/services.dart';

import '../utils/audio_manager.dart';
import 'platform.dart';

// Represents a player in the game world.
class Player extends SpriteComponent
    with CollisionCallbacks, KeyboardHandler, HasAncestor<GamePlay> {
  int _hAxisInput = 0;
  bool _jumpInput = false;
  bool _isOnGround = false;

  final double _gravity = 10;
  final double _jumpSpeed = 360;
  final double _moveSpeed = 200;

  final Vector2 _up = Vector2(0, -1);
  final Vector2 _velocity = Vector2.zero();

  Player(
    Image image, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
    Iterable<Component>? children,
  }) : super.fromImage(
          image,
          srcPosition: Vector2.zero(),
          srcSize: Vector2.all(32),
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
          children: children,
        );

  @override
  Future<void> onLoad() async {
    await add(CircleHitbox());
  }

  @override
  void onMount() {
    super.onMount();
    // As soon as the player is mounted,
    // connect it with the on-screen controls.
    ancestor.touchControls.connectPlayer(this);
  }

  @override
  void update(double dt) {
    // Modify components of velocity based on
    // inputs and gravity.
    _velocity.x = _hAxisInput * _moveSpeed;
    _velocity.y += _gravity;

    // Allow jump only if jump input is pressed
    // and player is already on ground.
    if (_jumpInput) {
      if (_isOnGround) {
        AudioManager.playSfx('Jump_15.wav');
        _velocity.y = -_jumpSpeed;
        _isOnGround = false;
      }
      _jumpInput = false;
    }

    // Clamp velocity along y to avoid player tunneling
    // through platforms at very high velocities.
    _velocity.y = _velocity.y.clamp(-_jumpSpeed, 150);

    // delta movement = velocity * time
    position += _velocity * dt;

    // Flip player if needed.
    if (_hAxisInput < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_hAxisInput > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // player must be on ground.
        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        // Resolve collision by moving player along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  // This method runs an opacity effect on player
  // to make it blink.
  void hit() {
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      ),
    );
  }

  // Makes the player jump forcefully.
  void airHop() {
    _jumpInput = true;
    _isOnGround = true;
  }

  // Setter for horizontal input.
  set hAxisInput(int value) {
    _hAxisInput = value;
  }

  // Setter for jump input.
  set jump(bool value) {
    _jumpInput = value;
  }
}
