import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_simple_platformer/game/actors/player.dart';
import 'package:flutter/rendering.dart';

// This class represents the on-screen controls
class TouchControls extends HudMarginComponent with ParentIsA<Viewport> {
  // A ref to the player.
  Player? _player;

  TouchControls({
    EdgeInsets? margin,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    Iterable<Component>? children,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          children: children,
          priority: priority,
        );

  // Controls the given player.
  void connectPlayer(Player player) {
    _player = player;
  }

  @override
  Future<void> onLoad() async {
    debugMode = true;
    const offset = 100.0;

    final leftButton = HudButtonComponent(
      button: RectangleComponent.square(size: 60),
      margin: const EdgeInsets.only(bottom: offset, left: offset),
      onPressed: () {
        _player?.hAxisInput = -1;
      },
      onReleased: () {
        _player?.hAxisInput = 0;
      },
    );
    await add(leftButton);

    final rightButton = HudButtonComponent(
      button: RectangleComponent.square(size: 60),
      position: Vector2(
        leftButton.position.x + leftButton.size.x + 20,
        leftButton.position.y,
      ),
      onPressed: () {
        _player?.hAxisInput = 1;
      },
      onReleased: () {
        _player?.hAxisInput = 0;
      },
    );
    await add(rightButton);

    final jumpButton = HudButtonComponent(
      button: RectangleComponent.square(size: 60),
      margin: const EdgeInsets.only(bottom: offset, right: offset),
      onPressed: () {
        _player?.jump = true;
      },
      onReleased: () {
        _player?.jump = false;
      },
    );
    await add(jumpButton);
  }
}
