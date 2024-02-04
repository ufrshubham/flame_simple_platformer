import 'package:flame_simple_platformer/game/game.dart';
import 'package:flame_simple_platformer/game/game_play.dart';
import 'package:flame_simple_platformer/game/overlays/main_menu.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  static const id = 'GameOver';
  final SimplePlatformer game;

  const GameOver({required this.game, super.key});

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
            ),
          ],
        ),
      ),
    );
  }
}
