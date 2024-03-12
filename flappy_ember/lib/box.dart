import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_ember/game.dart';

class Box extends SpriteComponent with HasGameRef<FlappyEmberGame> {
  Box({required Vector2 position})
      : super(position: position, size: initialSize);

  static Vector2 initialSize = Vector2.all(50);

  @override
  Future<void> onLoad() async {
    int retryCount = 0;
    bool assetLoaded = false;

    while (!assetLoaded) {
      try {
        final boxImage = await Flame.images.load('1.png');
        sprite = Sprite(boxImage);
        assetLoaded = true;
      } catch (e) {
        print('Error loading assets');
        retryCount++;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    if (!assetLoaded) {
      print('Failed to load asset after $retryCount attempts');
    }

    add(RectangleHitbox());
  }
}
