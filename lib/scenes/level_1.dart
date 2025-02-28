import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:fireboy_and_watergirl/main.dart';
import 'package:fireboy_and_watergirl/misc/misc.dart';

class LevelOneSprite extends SpriteComponent with HasGameReference<FireBoyAndWaterGirlGame> {
  final List<PositionComponent> _platforms = [
    FloorHitbox(
      position: Vector2(0, 0),
      size: Vector2(25, 720),
    ),
    FloorHitbox(
      position: Vector2(1255, 0),
      size: Vector2(25, 720),
    ),
    FloorHitbox(
      position: Vector2(33.19, 598), 
      size: Vector2(392.6, 21.6),
    ),
    FloorHitbox(
      position: Vector2(32, 697), 
      size: Vector2(560, 20),
    ),
    LavaPoolHitbox(
      position: Vector2(672.98, 703), 
      size: Vector2(161.6, 115.99),
    ),
    FloorHitbox(
      position: Vector2(750, 697), 
      size: Vector2(106, 20),
    ),
    WaterPoolHitbox(
      position: Vector2(937.0, 703), 
      size: Vector2(161.6, 115.99),
    ),
    FloorHitbox(
      position: Vector2(1020, 697), 
      size: Vector2(130, 20),
    ),
    FloorHitbox(
      position: Vector2(1197.19, 621.8), 
      size: Vector2(82.4, 97),
    ),
    DiagonalFloorHitbox(
      position: Vector2(1151.8, 621), 
      size: Vector2(40.59, 40.6),
    ),
    FloorHitbox(
      position: Vector2(1150.8, 652.39), 
      size: Vector2(20, 65),
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(1070, 548), 
      size: Vector2(28, 28),
    ),
    FloorHitbox(
      position: Vector2(950, 548), 
      size: Vector2(120, 20),
    ),
    AcidPoolHitbox(
      position: Vector2(869.19, 554.8), 
      size: Vector2(161.6, 115.99),
    ),
    FloorHitbox(
      position: Vector2(623.19, 547.99), 
      size: Vector2(165.59, 20.80),
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(546.60, 498.39), 
      size: Vector2(85, 70),
    ),
    FloorHitbox( 
      position: Vector2(32.39, 498.39), 
      size: Vector2(525.0, 20),
    ),
    FanHitbox(
      maxHeight: 390,
      position: Vector2(70.39, 478.98),
      size: Vector2(44, 20)
    ),
    FloorHitbox( 
      position: Vector2(166.39, 375.19), 
      size: Vector2(490.4, 20),
    ),
  ];

  @override
  Future<void> onLoad() async {
    final backgroundImage = await Flame.images.load('levels/level_1.png');
    sprite = Sprite(backgroundImage); 
    size = Vector2(1280, 720);    

    for ( final platform in _platforms ) {
      await add(platform);
    }
  }
}