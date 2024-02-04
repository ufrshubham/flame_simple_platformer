import 'package:flame_simple_platformer/game/game.dart';
import 'package:flame_simple_platformer/game/game_play.dart';
import 'package:flame_simple_platformer/game/overlays/settings.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';
  final SimplePlatformer game;

  const MainMenu({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.add(GamePlay());
                },
                child: const Text('Play'),
              ),
            ),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.overlays.add(Settings.id);
                },
                child: const Text('Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
