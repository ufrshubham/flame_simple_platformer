import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/game.dart';

void main() {
  runApp(const MyApp());
}

final _game = SimplePlatformer();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget(
          game: _game,
        ),
      ),
    );
  }
}
