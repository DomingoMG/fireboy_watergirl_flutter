import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:fireboy_and_watergirl/misc/misc.dart';
import 'package:fireboy_and_watergirl/config/enums/hitbox_type.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/characters/fireboy/fireboy.dart';
import 'package:fireboy_and_watergirl/characters/watergirl/watergirl.dart';

class AcidPoolHitbox extends SpriteAnimationComponent with CollisionCallbacks, DragCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {
  AcidPoolHitbox({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    size: size,
    position: position,
    anchor: Anchor.center,
  );

  bool isResizing = false;
  final double resizeThreshold = 15.0; // Área de detección para redimensionar
  late RectangleHitbox groundHitbox;
  late SpriteAnimation idleAnimation;

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      HitboxType.acidPlatform.assetName,
      SpriteAnimationData.sequenced(
        amount: 15, 
        stepTime: .1, 
        textureSize: Vector2(128, 128)
      ),
    );
    
    add(DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(0, 50),
      size: Vector2(54.2, 25.4),
    ));
    add(DiagonalFloorHitbox(
      diagonalLeftStart: true,
      position: Vector2(111.60, 51.60),
      size: Vector2(54.2, 25.4),
    ));
    groundHitbox = RectangleHitbox(
      collisionType: CollisionType.passive,
      size: Vector2(130, 12), // Altura positiva
      position: Vector2(18, size.y-65), // Moverlo abajo
    );
    add(groundHitbox);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    final isColliding = groundHitbox.isColliding;
    if( other is WaterGirlAnimation ){
      if( isColliding ) other.dead();
    } else if( other is FireboyAnimation ){
      if( isColliding ) other.dead();
    } else if ( other is BoxHitbox ) {
      other.respawn();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
