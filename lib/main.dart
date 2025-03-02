import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/menus.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';

void main() {
  runApp(GameWidget(
    game: FireBoyAndWaterGirlGame(),
    overlayBuilderMap: {
      MainMenu.pathRoute: (context, game) => MainMenu(game: game as FireBoyAndWaterGirlGame),
    },
    initialActiveOverlays: const [MainMenu.pathRoute],
  ));
}