import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/characters/fireboy/fireboy.dart';
import 'package:fireboy_and_watergirl/characters/watergirl/watergirl.dart';
import 'package:fireboy_and_watergirl/config/enums/hitbox_type.dart';


class DoorHitbox extends SpriteComponent with CollisionCallbacks, DragCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {
  DoorHitbox({
    required Vector2 position,
    required Vector2 size,
    required this.doorType,
  }) {
    this.position = position;
    this.size = size;
  }

  final String doorType;
  bool isResizing = false;
  final double resizeThreshold = 15.0; // Área de detección para redimensionar

  @override
  Future<void> onLoad() async {
    sprite = Sprite(await Flame.images.load(
      doorType == 'blue' 
      ? HitboxType.blueDoor.assetName 
      : HitboxType.redDoor.assetName
    ));
    await add(RectangleHitbox(
      size: Vector2(40, 55),
      position: Vector2(10, 20)
    )); // Agregamos hitbox para detección de colisión
  }
    
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {   
    if( other is FireboyAnimation && doorType == 'red' ){
      game.level?.isFireboyAtDoor = true;
      other.position.x = position.x+30.5;
    } else if( other is WaterGirlAnimation && doorType == 'blue' ){
      game.level?.isWaterGirlAtDoor = true;
      other.position.x = position.x+30.5;
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if( other is FireboyAnimation && doorType == 'red' ){
      game.level?.isFireboyAtDoor = false;
    } else if( other is WaterGirlAnimation && doorType == 'blue' ){
      game.level?.isWaterGirlAtDoor = false;
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
    debugPrint('Door position: x=${position.x}, y=${position.y}, Size: w=${size.x}, h=${size.y}');
    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    if( !kDebugMode ) return;
    final paint = Paint()..color = Colors.red.withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromLTWH(size.x - resizeThreshold, size.y - resizeThreshold, resizeThreshold, resizeThreshold),
      paint,
    );
    super.render(canvas);
  }
}
