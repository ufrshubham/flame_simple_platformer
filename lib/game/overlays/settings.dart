import 'package:flame_simple_platformer/game/game.dart';
import 'package:flame_simple_platformer/game/overlays/main_menu.dart';
import 'package:flame_simple_platformer/game/utils/audio_manager.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  static const id = 'Settings';
  final SimplePlatformer game;

  const Settings({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: ValueListenableBuilder<bool>(
                valueListenable: AudioManager.sfx,
                builder: (context, sfx, child) => SwitchListTile(
                  title: const Text('Sound Effects'),
                  value: sfx,
                  onChanged: (value) => AudioManager.sfx.value = value,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: ValueListenableBuilder<bool>(
                valueListenable: AudioManager.bgm,
                builder: (context, bgm, child) => SwitchListTile(
                  title: const Text('Background Music'),
                  value: bgm,
                  onChanged: (value) => AudioManager.bgm.value = value,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.overlays.add(MainMenu.id);
                },
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
