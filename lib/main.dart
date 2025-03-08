import 'package:fireboy_and_watergirl/overlays/waiting_player.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/overlays/lobby_menu.dart';
import 'package:fireboy_and_watergirl/overlays/main_menu.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MaterialApp(
      home: GameWidget(
        game: FireBoyAndWaterGirlGame(),
        overlayBuilderMap: {
          MainMenuOverlay.pathRoute: (context, game) => MainMenuOverlay(game: game as FireBoyAndWaterGirlGame),
          LobbyMenuOverlay.pathRoute: (context, game) => LobbyMenuOverlay(game: game as FireBoyAndWaterGirlGame),
          WaitingPlayerOverlay.pathRoute: (context, game) => WaitingPlayerOverlay(game: game as FireBoyAndWaterGirlGame),
        },
        initialActiveOverlays: const [MainMenuOverlay.pathRoute],
      ),
    ),
  ));
}