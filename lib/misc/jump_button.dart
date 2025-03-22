import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/characters/character_animation.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';

class JumpButton extends PositionComponent with TapCallbacks, HasGameReference<FireBoyAndWaterGirlGame> {
  final CharacterAnimation player;

  JumpButton(this.player) : super(size: Vector2(70, 70));

  @override
  Future<void> onLoad() async {
    position = Vector2(game.size.x - 120, game.size.y - 100); // 🔥 Posición en la pantalla
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blue.withValues(alpha: 0.7), // 🔵 Color azul semitransparente
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump(sendEvent: true);
    super.onTapDown(event);
  }
}
