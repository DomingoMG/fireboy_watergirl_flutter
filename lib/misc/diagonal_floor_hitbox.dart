import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/characters/character_animation.dart';

class DiagonalFloorHitbox extends PositionComponent with CollisionCallbacks, DragCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {
  DiagonalFloorHitbox({
    required Vector2 position,
    required Vector2 size,
    this.diagonalLeftStart = true
  }) : super(
    size: size, 
    position: position
  );

  final bool diagonalLeftStart;
  bool isResizing = false;
  final double resizeThreshold = 15.0; // Área de detección para redimensionar

  @override
  Future<void> onLoad() async => await _buildPolygonHitbox();

  Future<void> _buildPolygonHitbox() async {
    if( diagonalLeftStart ) {
      await add(PolygonHitbox([
        Vector2(0, size.y),      
        Vector2(size.x, 0),      
        Vector2(size.x, size.y), 
      ]));
    } else {
      await add(PolygonHitbox([
        Vector2(size.x, size.y),  
        Vector2(0, 0),            
        Vector2(0, size.y),       
      ]));
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if( other is CharacterAnimation ){
      final lowerY = intersectionPoints.map((p) => p.y).reduce((a, b) => a < b ? a : b);

      // Definir un umbral para detectar si la colisión es cerca de los pies
      double footThreshold = position.y + other.size.y-150; // 10 píxeles de margen


      if (lowerY >= footThreshold) {
        // Si la colisión está cerca de los pies, ajustamos la posición sobre la rampa
        other.position.y = lowerY - other.size.y+32;
        other.velocity.y = 0;
        other.onGround = true;
      } else {
        // Si la colisión está más arriba, permitimos que el personaje siga cayendo
        other.onGround = false;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if( other is CharacterAnimation ){
      other.onGround = false;
    }
    super.onCollisionEnd(other);
  }

  @override
  void onDragStart(DragStartEvent event) {
    Vector2 localPosition = event.localPosition;

    // Verificar si el usuario está agarrando la esquina inferior derecha
    if ((localPosition.x >= size.x - resizeThreshold && localPosition.y >= size.y - resizeThreshold)) {
      isResizing = true;
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
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
    isResizing = false;
    debugPrint('Floor diagonal position: x=${position.x}, y=${position.y}, Size: w=${size.x}, h=${size.y}');
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
