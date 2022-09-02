import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

extension ShakyCam on CameraComponent {
  void shake() {
    viewfinder.add(
      RotateEffect.by(
        .1,
        NoiseEffectController(
          duration: .5,
          frequency: 200,
        ),
      ),
    );
  }

  void stopShaking() {
    for (var effect in viewfinder.children.whereType<RotateEffect>()) {
      // Not working for some reason...
      effect.controller.setToEnd();
      effect.pause();
      effect.removeFromParent();
    }
  }
}
