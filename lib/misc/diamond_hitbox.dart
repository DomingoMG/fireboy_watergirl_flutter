import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:fireboy_and_watergirl/characters/fireboy/fireboy.dart';
import 'package:fireboy_and_watergirl/characters/watergirl/watergirl.dart';
import 'package:fireboy_and_watergirl/config/config.dart';

class DiamondHitbox extends SpriteComponent with CollisionCallbacks {
  DiamondHitbox({
    required Vector2 position,
    required Vector2 size,
    required this.diamondType,
  }) : super(size: size, position: position);
  final String diamondType;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(await Flame.images.load('gems/${diamondType}_diamond.png'));
    await add(RectangleHitbox(
      size: Vector2(25, 25),
      position: Vector2(12, 14),
    ));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if( other is FireboyAnimation && diamondType == 'red' ){
      _collectDiamond();
    } else if( other is WaterGirlAnimation && diamondType == 'blue' ){
      _collectDiamond();
    } else if( diamondType == 'green' ){
      _collectDiamond();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _collectDiamond() {
    // Reproducir sonido
    AudioManager.playSound(AudioType.coin, volume: 0.2);


    // Eliminar el diamante del juego
    removeFromParent();
  }
}