import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyEvent, LogicalKeyboardKey;
import 'package:fireboy_and_watergirl/config/sockets/models/player_movement.dart';
import 'package:fireboy_and_watergirl/providers/game_provider.dart';
import 'package:fireboy_and_watergirl/providers/movement_provider.dart';
import 'package:fireboy_and_watergirl/providers/player_provider.dart';
import 'package:fireboy_and_watergirl/config/config.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';

abstract class CharacterAnimation extends SpriteAnimationComponent
    with RiverpodComponentMixin, HasGameReference<FireBoyAndWaterGirlGame>, KeyboardHandler, CollisionCallbacks {
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
  JoystickComponent? joystick;
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
  void onMount() {
    addToGameWidgetBuild((){
      final gameStart = ref.read(providerGameStart).value;
      if( gameStart == null ) return;
      ref.listen(providerPlayerMovement, ( previous, next ) {
        _playerOnlineMovement(next);
      });
    });
    super.onMount();
  }


  void _playerOnlineMovement(PlayerMoveModel playerMove) {
    final player = ref.read(providerPlayer);
    final gameStart = ref.read(providerGameStart).value;

    if (gameStart == null) return;

    // 📌 Solo actualizar si el personaje en el evento es el correcto
    debugPrint('✅ Personaje en el evento: ${playerMove.character}');
    if (playerMove.character != characterType) return;

    // 📌 Ignorar si el evento es del propio jugador
    if (playerMove.playerId == player.id) return;

    // 🔥 Actualizar solo el otro jugador
    position.setValues(playerMove.position.x, playerMove.position.y);

    switch (playerMove.action) {      
      case PlayerMovementAction.moveLeft:
        final keyEventOnline = characterType == 'fireboy' ? LogicalKeyboardKey.keyA : LogicalKeyboardKey.arrowLeft;
        moveFromKeyEvent({ keyEventOnline }, false);
        break;
      case PlayerMovementAction.moveRight:
        final keyEventOnline = { characterType == 'fireboy' ? LogicalKeyboardKey.keyD : LogicalKeyboardKey.arrowRight };
        moveFromKeyEvent(keyEventOnline, false);
        break;
      case PlayerMovementAction.jump:
        jump();
        break;
      default:
        moveFromKeyEvent({}, false);
        velocity.x = 0;
    }
  }

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
    if (joystick != null) moveWithJoystick();

    position += velocity * dt;
    if (!onGround) velocity.y += gravity * dt;
    super.update(dt);
  }

  void moveWithJoystick() {
    final playerMovementController = ref.read(providerPlayerMovement.notifier);
    if (joystick != null) {
      double threshold = 0.60; // 🔥 Requiere mover el joystick un 60% para que empiece a moverse
      double joystickIntensity = joystick!.delta.length; // Cuánto se ha movido el joystick (0 - 1)
      
      if(joystickIntensity < threshold) {
        if( animation == idleAnimation ) return;
        velocity.x = 0; // Si no se empuja lo suficiente, no se mueve
        animation = idleAnimation;
        playerMovementController.sendMove(PlayerMovementAction.idle, position.x, position.y);
      } else {
        double normalizedSpeed = ((joystickIntensity - threshold) / (1 - threshold)).clamp(0.0, 1.0); 
        velocity.x = joystick!.delta.x.sign * speed * normalizedSpeed; // Aplicar velocidad solo cuando pasa el umbral
        animation = joystick!.delta.x < 0 ? walkLeftAnimation : walkRightAnimation;
        final playerMovementAction = joystick!.delta.x < 0 ? PlayerMovementAction.moveLeft : PlayerMovementAction.moveRight;
        playerMovementController.sendMove(playerMovementAction, position.x, position.y);
      }
    } else {
      velocity.x = 0;
      animation = idleAnimation;
      playerMovementController.sendMove(PlayerMovementAction.idle, position.x, position.y);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if( stopMoving ) return true;
    
    velocity.x = 0;
    moveFromKeyEvent(keysPressed, true);
    jumpFromKeyEvent(keysPressed, true);
    return true;
  }

  void moveFromKeyEvent(Set<LogicalKeyboardKey> keysPressed, bool sendEvent);
  void jumpFromKeyEvent(Set<LogicalKeyboardKey> keysPressed, bool sendEvent);
  void dead() {
    AudioManager.playSound(AudioType.death);
    resetPosition();
  }

  void jump() {
    if( !onGround ) return;
    final playerMovementController = ref.read(providerPlayerMovement.notifier);
    playerMovementController.sendMove(PlayerMovementAction.jump, position.x, position.y);
    if( characterType == 'fireboy' ) {
      AudioManager.playSound(AudioType.fireboyJump);
    } else {
      AudioManager.playSound(AudioType.waterGirlJump);
    }
    animation = jumpAnimation;
    velocity.y = jumpPower;
    isJumping = true;
    onGround = false;
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