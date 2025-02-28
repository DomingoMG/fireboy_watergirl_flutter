import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/config/enums/hitbox_type.dart';


class FanHitbox extends SpriteComponent with CollisionCallbacks {
  final double maxHeight;
  final double speed = 50; // Velocidad de movimiento
  double minHeight = 0;
  
  bool isActive = false; // Si el elevador está subiendo
  bool isPlayerOnTop = false; // Si el jugador está encima

  FanHitbox({
    required this.maxHeight,
    required Vector2 position,
    required Vector2 size,
  }) {
    this.position = position;
    this.size = size;
    minHeight = position.y;
  }

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

}
