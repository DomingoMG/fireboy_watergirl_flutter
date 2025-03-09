import 'package:flame/components.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/player_movement.dart';
import 'package:fireboy_and_watergirl/providers/movement_provider.dart';

class FireboyAnimation extends CharacterAnimation {
  FireboyAnimation() : super(
    characterType: 'fireboy',
    anchor: Anchor.center,
    size: Vector2(64, 64),
    position: Vector2(53, 650)
  );

  @override
  void jumpFromKeyEvent(Set<LogicalKeyboardKey> keysPressed, bool sendEvent) {
    final playerMovementController = ref.read(providerPlayerMovement.notifier);
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      jump();
      if( !sendEvent ) return;
      playerMovementController.sendMove(PlayerMovementAction.jump, position.x, position.y);
    }
  }

 @override
  void moveFromKeyEvent(Set<LogicalKeyboardKey> keysPressed, bool sendEvent) {
    final playerMovementController = ref.read(providerPlayerMovement.notifier);
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      animation = walkLeftAnimation;
      velocity.x = -speed;
      if( !sendEvent ) return;
      playerMovementController.sendMove(PlayerMovementAction.moveLeft, position.x, position.y);
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      animation = walkRightAnimation;
      velocity.x = speed;
      if( !sendEvent ) return;
      playerMovementController.sendMove(PlayerMovementAction.moveRight, position.x, position.y);
    } else {
      animation = idleAnimation;
      if( !sendEvent ) return;
      playerMovementController.sendMove(PlayerMovementAction.idle, position.x, position.y);
    }
  }
}