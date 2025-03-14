import 'package:flame/components.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/config/config.dart';

class WaterGirlAnimation extends CharacterAnimation {
  WaterGirlAnimation() : super(
    characterType: 'watergirl',
    anchor: Anchor.center,
    size: Vector2(64, 64),
    position: Vector2(83, 650)
  );

  @override
  void jump(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) && onGround) {
      AudioManager.playSound(AudioType.waterGirlJump);
      animation = jumpAnimation;
      velocity.y = jumpPower;
      isJumping = true;
      onGround = false;
    }
  }

  @override
  void move(Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      animation = walkLeftAnimation;
      velocity.x = -speed;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      animation = walkRightAnimation;
      velocity.x = speed;
    } else {
      animation = idleAnimation;
    }
  }
}