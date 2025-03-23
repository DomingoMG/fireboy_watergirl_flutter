import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/config/constants/characters_config.dart';
import 'package:fireboy_and_watergirl/config/enums/hitbox_type.dart';
import 'package:fireboy_and_watergirl/misc/floor_hitbox.dart';
import 'package:fireboy_and_watergirl/characters/character_animation.dart';

class BoxHitbox extends SpriteComponent
    with CollisionCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {
  BoxHitbox({
    required super.position,
    required super.size,
  }) {
    initialPosition = position.clone();
  }

  late final Vector2 initialPosition;
  CharacterAnimation? characterOnTop;
  Vector2 velocity = Vector2.zero();
  double gravity = 600;
  bool onGround = false;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(await Flame.images.load(HitboxType.box.assetName));

    // Este hitbox está centrado por defecto, y es activo para colisiones reales
    add(RectangleHitbox(
      collisionType: CollisionType.active,
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Aplicar gravedad
    if (!onGround) {
      velocity.y += gravity * dt;
    }

    // Movimiento por velocidad
    position += velocity * dt;

    // Fricción horizontal
    velocity.x *= 0.9;

    // Resetear estado
    onGround = false;

    // 🔁 Mover al personaje encima
    if (characterOnTop != null && velocity.x.abs() > 0.1) {
      characterOnTop!.position.x += velocity.x * dt;
    }

    if (position.y > CharactersConfig.screenHeight + 200 ||
        position.x + 50 > CharactersConfig.screenWidth ||
        position.x - 50 < 0) {
      respawn();
    }
  }

  void respawn() {
    position = initialPosition.clone();
    velocity = Vector2.zero();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is FloorHitbox && velocity.y > 0) {
      onGround = true;
      velocity.y = 0;

      // Ajustar posición verticalmente (esto se puede refinar)
      position.y = other.toRect().top - size.y;
    }

    if (other is CharacterAnimation) {
      final characterBottom = other.position.y + other.size.y;
      final boxTop = position.y;

      // Detectar si está encima
      final isOnTop = other.velocity.y > 0 &&
          characterBottom > boxTop &&
          characterBottom < boxTop + 40;

      if (isOnTop) {
        // Alinearlo encima de la caja
        other.position.y = boxTop - other.size.y + 32;
        other.velocity.y = 0;
        other.onGround = true;
        characterOnTop = other;
      } else {
        // Evaluar los puntos de colisión para ver si vienen del lateral
        final lateralCollision = intersectionPoints.any((point) {
          final y = point.y;
          return y > boxTop + 10; // Está colisionando más abajo del top
        });

        if (lateralCollision) {
          final horizontalDistance = (position.x - other.position.x).abs();

          if (horizontalDistance < size.x * 0.8) {
            final direction = other.velocity.x.sign;
            velocity.x += 50 * direction;
          }
        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is CharacterAnimation) other.onGround = false;
    if (other is CharacterAnimation && other == characterOnTop) {
      characterOnTop = null;
    }
    super.onCollisionEnd(other);
  }
}
