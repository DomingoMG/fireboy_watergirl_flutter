import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/characters/fireboy/fireboy.dart';
import 'package:fireboy_and_watergirl/characters/watergirl/watergirl.dart';

class FloorHitbox extends PositionComponent with CollisionCallbacks, DragCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {
  FloorHitbox({
    required Vector2 position,
    required Vector2 size,
  }) : super(
    size: size, 
    position: position
  );  
  bool isResizing = false;
  final double resizeThreshold = 15.0; // Área de detección para redimensionar

  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if( other is CharacterAnimation ){
      final double characterBottom = other.position.y + other.size.y;  // Parte inferior del personaje
      final double characterTop = other.position.y;              // Parte superior del personaje
      final double characterLeft = other.position.x;             // Lado izquierdo del personaje
      final double characterRight = other.position.x + other.size.x;   // Lado derecho del personaje

      final double blockBottom = position.y + size.y; // Parte inferior del bloque
      final double blockTop = position.y;                   // Parte superior del bloque
      final double blockLeft = position.x;                  // Lado izquierdo del bloque
      final double blockRight = position.x + size.x+70;  // Lado derecho del bloque

      // Calcula la diferencia de colisión en cada lado
      double bottomDiff = (characterBottom - blockTop).abs();
      double topDiff = (characterTop - blockBottom).abs();
      double leftDiff = (characterLeft - blockRight).abs();
      double rightDiff = (characterRight - blockLeft).abs();

      CharacterAnimation? character = other is FireboyAnimation 
        ? other : other is WaterGirlAnimation 
        ? other : null;

      // Determina la dirección de la colisión
      if (bottomDiff < topDiff && bottomDiff < leftDiff && bottomDiff < rightDiff) {
        // Colisión con el suelo (parte superior del bloque)
        if ( other.onGround == false ) {
          other.position.y = blockTop - other.size.y+32;
          character?.velocity.y = 0;
          character?.onGround = true;
          debugPrint("📏 Colisión con el SUELO (parte superior del bloque)");
        }
  
      } else if (topDiff < bottomDiff && topDiff < leftDiff && topDiff < rightDiff) {
        // Colisión con el techo (parte inferior del bloque)
        character?.velocity.y = 0;
        other.position.y = blockBottom+20; // Evita que se quede dentro del bloque
        debugPrint("🛑 Colisión con el TECHO (parte inferior del bloque)");
      } else if (leftDiff < rightDiff) {
        // Colisión con la pared derecha del bloque
        character?.velocity.x = 0;
        other.position.x = blockRight-45; // Ajusta la posición para evitar penetración
        debugPrint("⬅️ Colisión con la PARED DERECHA");
      } else {
        // Colisión con la pared izquierda del bloque
        character?.velocity.x = 0;
        other.position.x = blockLeft - other.size.x+42; // Ajusta la posición
        debugPrint("➡️ Colisión con la PARED IZQUIERDA");
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if( other is CharacterAnimation && other.onGround == true ){
      other.onGround = false;
    }
    super.onCollisionEnd(other);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if( !kDebugMode ) return;
    Vector2 localPosition = event.localPosition;

    // Verificar si el usuario está agarrando la esquina inferior derecha
    if ((localPosition.x >= size.x - resizeThreshold && localPosition.y >= size.y - resizeThreshold)) {
      isResizing = true;
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
  if( !kDebugMode ) return;
   if (isResizing) {
      // Redimensionar sin que se invierta
      size += event.localDelta;
      size.clamp(Vector2(20, 20), Vector2(500, 500)); // Define un tamaño mínimo y máximo
    } else {
      // Mueve el bloque si no está en modo redimensionamiento
      position += event.localDelta;
    }
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if( !kDebugMode ) return;
    isResizing = false;
    debugPrint('Floor position: x=${position.x}, y=${position.y}, Size: w=${size.x}, h=${size.y}');
    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red.withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromLTWH(size.x - resizeThreshold, size.y - resizeThreshold, resizeThreshold, resizeThreshold),
      paint,
    );
    super.render(canvas);
  }
}
