import 'package:flame/components.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:fireboy_and_watergirl/characters/character_animation.dart';

class FireboyAnimation extends CharacterAnimation {
  FireboyAnimation() : super(
    characterType: 'fireboy',
    anchor: Anchor.center,
    size: Vector2(64, 64),
    position: Vector2(53, 650)
  );

  @override
  void jumpFromKeyEvent(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      jump();
    }
  }

 @override
  void moveFromKeyEvent(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      animation = walkLeftAnimation;
      velocity.x = -speed;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      animation = walkRightAnimation;
      velocity.x = speed;
    } else {
      animation = idleAnimation;
    }
  }
}