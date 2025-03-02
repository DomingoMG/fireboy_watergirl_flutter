import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart' show KeyEvent, LogicalKeyboardKey;
import 'package:fireboy_and_watergirl/config/config.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';

abstract class CharacterAnimation extends SpriteAnimationComponent
    with HasGameReference<FireBoyAndWaterGirlGame>, KeyboardHandler, CollisionCallbacks {
  CharacterAnimation({
    required this.characterType,
    required Vector2 size,
    required Vector2 position,
    required Anchor anchor,
  }) : super() {
    super.size = size;
    super.position = position;
    super.anchor = anchor;
    initialPosition = Vector2.copy(position);
  }

  final String characterType;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation walkRightAnimation;
  late SpriteAnimation walkLeftAnimation;
  late SpriteAnimation jumpAnimation;

  Vector2 initialPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  double gravity = CharactersConfig.gravity;
  double jumpPower = CharactersConfig.jumpPower;
  double speed = CharactersConfig.speed;

  bool isAlive = true;
  bool isJumping = false;
  bool onGround = false;
  bool stopMoving = false;

  @override
  Future<void> onLoad() async {
    idleAnimation = await game.loadSpriteAnimation(
      'characters/${characterType}_idle.png',
      SpriteAnimationData.sequenced(amount: characterType == 'fireboy' ? 5 : 11, stepTime: .1, textureSize: Vector2(128, 128)),
    );
    walkRightAnimation = await game.loadSpriteAnimation(
      'characters/${characterType}_walk_right.png',
      SpriteAnimationData.sequenced(amount: 8, stepTime: .1, textureSize: Vector2(128, 128)),
    );
    walkLeftAnimation = await game.loadSpriteAnimation(
      'characters/${characterType}_walk_left.png',
      SpriteAnimationData.sequenced(amount: 8, stepTime: .1, textureSize: Vector2(128, 128)),
    );
    jumpAnimation = await game.loadSpriteAnimation(
      'characters/${characterType}_jump.png',
      SpriteAnimationData.sequenced(amount: 8, stepTime: .1, textureSize: Vector2(128, 128)),
    );
    animation = idleAnimation;

    add(RectangleHitbox(size: Vector2(24, 50), position: Vector2(20, 14), isSolid: true));
    add(RectangleHitbox(size: Vector2(8, 10), position: Vector2(10, 30))); 
    add(RectangleHitbox(size: Vector2(8, 10), position: Vector2(42, 30))); 
  }

  @override
  void update(double dt) {
    position += velocity * dt;
    if (!onGround) velocity.y += gravity * dt;
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if( stopMoving ) return true;
    
    velocity.x = 0;
    move(keysPressed);
    jump(keysPressed);
    return true;
  }

  void move(Set<LogicalKeyboardKey> keysPressed);
  void jump(Set<LogicalKeyboardKey> keysPressed);
  void dead() {
    AudioManager.playSound(AudioType.death);
    resetPosition();
  }

  void resetPosition() {
    position = initialPosition;
    velocity.setValues(0, 0); 
    onGround = false;
    isJumping = false;
    isAlive = true;
    stopMoving = false;
    animation = idleAnimation; 
  }

  void finishLevel() {
    animation = idleAnimation;
    velocity.setValues(0, 0);
    stopMoving = true;
  }
}