import 'package:flame_simple_platformer/game/overlays/settings.dart';
import 'package:flutter/material.dart';

import '../game.dart';
import '../game_play.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';
  final SimplePlatformer game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.add(GamePlay());
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.overlays.add(Settings.id);
                },
                child: const Text('Settings'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
