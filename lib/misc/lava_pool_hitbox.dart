import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:fireboy_and_watergirl/misc/misc.dart';
import 'package:fireboy_and_watergirl/config/enums/hitbox_type.dart';
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/characters/fireboy/fireboy.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
class LavaPoolHitbox extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {

  LavaPoolHitbox({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  late RectangleHitbox groundHitbox;

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      HitboxType.lavaPlatform.assetName,
      SpriteAnimationData.sequenced(
        amount: 15,
        stepTime: .04,
        textureSize: Vector2(128, 128),
      ),
    );

    // Piso sobre el que Fireboy puede caminar
    groundHitbox = RectangleHitbox(
      priority: 1,
      isSolid: true,
      collisionType: CollisionType.active,
      size: Vector2(160, 12),
      position: Vector2(0, size.y - 50),
    );

    addAll([
      groundHitbox,
      DiagonalFloorHitbox(
        diagonalLeftStart: false,
        position: Vector2(0, 50),
        size: Vector2(54.2, 25.4),
      ),
      DiagonalFloorHitbox(
        diagonalLeftStart: true,
        position: Vector2(111.60, 51.60),
        size: Vector2(54.2, 25.4),
      ),
      DeathZone(
        characterType: 'watergirl',
        size: Vector2(130, 12),
        position: Vector2(18, size.y-65),
      ),
    ]);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    final isColliding = groundHitbox.isColliding;

    if (other is FireboyAnimation) {
      if (isColliding) {
        other.onGround = true;
        other.position.y = position.y + groundHitbox.position.y - other.size.y - 25;
      }
    }

    if (other is BoxHitbox) {
      if (isColliding) {
        other.onGround = true;
        other.position.y = position.y + groundHitbox.position.y - other.size.y - 55;
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is CharacterAnimation) other.onGround = false;
    super.onCollisionEnd(other);
  }
}


class DeathZone extends PositionComponent
    with CollisionCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {
  
  DeathZone({
    required this.characterType,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  final String characterType;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Este hitbox solo detecta, no bloquea
    add(RectangleHitbox(
      collisionType: CollisionType.passive
    ));
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if( other is CharacterAnimation && other.characterType == characterType ) {
      other.dead();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
