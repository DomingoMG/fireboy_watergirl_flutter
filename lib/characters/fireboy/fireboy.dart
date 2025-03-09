import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/config/config.dart';

class FireboyAnimation extends CharacterAnimation with RiverpodComponentMixin {
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

  void jump() {
    if( !onGround ) return;
    AudioManager.playSound(AudioType.fireboyJump);
    animation = jumpAnimation;
    velocity.y = jumpPower;
    isJumping = true;
    onGround = false;
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