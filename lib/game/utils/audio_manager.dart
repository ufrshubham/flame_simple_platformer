import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

// This class is responsible for playing all the sound effects
// and background music in this game.
class AudioManager {
  static final sfx = ValueNotifier(true);
  static final bgm = ValueNotifier(true);
  static bool play = false;

  static Future<void> init() async {
    FlameAudio.bgm.initialize();
    try {
      await FlameAudio.audioCache.loadAll([
        'Blop_1.wav',
        'Collectibles_6.wav',
        'Hit_2.wav',
        'Jump_15.wav',
        'Winning_Sight.wav',
      ]);
    } catch (_) {}
  }

  static void playSfx(String file) {
    if (sfx.value && play) {
      FlameAudio.play(file);
    }
  }

  static void playBgm(String file) {
    if (bgm.value && play) {
      FlameAudio.bgm.play(file);
    }
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    if (bgm.value && play) {
      FlameAudio.bgm.resume();
    }
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }
}
