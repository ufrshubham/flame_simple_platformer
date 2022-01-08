import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

// Represents a level in game
class Level extends Component {
  final String levelName;

  Level(this.levelName) : super();

  @override
  Future<void>? onLoad() async {
    final level = await TiledComponent.load(
      levelName,
      Vector2.all(32),
    );
    add(level);

    return super.onLoad();
  }
}
