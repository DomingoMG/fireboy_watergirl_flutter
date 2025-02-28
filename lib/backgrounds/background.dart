import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BackgroundOneSprite extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    final backgroundImage = await Flame.images.load('background/background_1.png');
    sprite = Sprite(backgroundImage); 
    size = Vector2(1280, 720);
  }
}
