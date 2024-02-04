import 'package:flame/game.dart';
import 'package:flame_simple_platformer/game/game.dart';
import 'package:flame_simple_platformer/game/overlays/game_over.dart';
import 'package:flame_simple_platformer/game/overlays/main_menu.dart';
import 'package:flame_simple_platformer/game/overlays/pause_menu.dart';
import 'package:flame_simple_platformer/game/overlays/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// A single instance to avoid creation of
// multiple instances in every build.
final _game = SimplePlatformer();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Platformer',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget<SimplePlatformer>(
          game: kDebugMode ? SimplePlatformer() : _game,
          overlayBuilderMap: {
            MainMenu.id: (context, game) => MainMenu(game: game),
            PauseMenu.id: (context, game) => PauseMenu(game: game),
            GameOver.id: (context, game) => GameOver(game: game),
            Settings.id: (context, game) => Settings(game: game),
          },
          initialActiveOverlays: const [MainMenu.id],
        ),
      ),
    );
  }
}
