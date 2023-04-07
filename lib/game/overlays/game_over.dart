import 'package:flutter/material.dart';

import '../game.dart';
import '../game_play.dart';
import 'main_menu.dart';

class GameOver extends StatelessWidget {
  static const id = 'GameOver';
  final SimplePlatformer game;

  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(100),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.resumeEngine();
                  game.removeAll(game.children);
                  game.add(GamePlay());
                },
                child: const Text('Restart'),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  game.overlays.remove(id);
                  game.resumeEngine();
                  game.removeAll(game.children);
                  game.overlays.add(MainMenu.id);
                },
                child: const Text('Exit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
