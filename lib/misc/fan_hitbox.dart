import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';
import 'package:fireboy_and_watergirl/config/enums/hitbox_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;


class FanHitbox extends SpriteComponent with CollisionCallbacks, DragCallbacks {
  final double maxHeight;
  final double speed = 50; // Velocidad de movimiento
  double minHeight = 0;
  
  bool isActive = false; // Si el elevador está subiendo
  bool isPlayerOnTop = false; // Si el jugador está encima

  FanHitbox({
    required this.maxHeight,
    required this.minHeight,
    required Vector2 position,
    required Vector2 size,
  }) {
    this.position = position;
    this.size = size;
    minHeight = position.y;
  }

  bool isResizing = false;
  final double resizeThreshold = 15.0; // Área de detección para redimensionar

  @override
  Future<void> onLoad() async {
    sprite = Sprite(await Flame.images.load(HitboxType.whiteFan.assetName));
    await add(RectangleHitbox()); // Agregamos hitbox para detección de colisión
  }

  @override
  void update(double dt) {
    super.update(dt);

    // print('Elevador: x=${position.x}, y=${position.y}, w=${size.x}, h=${size.y}');
    if (isPlayerOnTop && position.y > maxHeight ) {
      position.y -= speed * dt; // Subir
    } else if (!isPlayerOnTop && position.y < minHeight) {
      position.y += speed * dt; // Bajar si el jugador se fue
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if( other is CharacterAnimation ){
      AudioManager.playSound(AudioType.fan);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if( other is CharacterAnimation ){  
      isPlayerOnTop = true;
      other.position.y = position.y - other.size.y +32;
      other.onGround = true;
    }
    super.onCollision(intersectionPoints, other);
  }


  @override
  void onCollisionEnd(PositionComponent other) {
    if( other is CharacterAnimation ){
      isPlayerOnTop = false;
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
    debugPrint('Fan position: x=${position.x}, y=${position.y}, Size: w=${size.x}, h=${size.y}');
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
