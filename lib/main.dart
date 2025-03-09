import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/overlays/lobby_menu.dart';
import 'package:fireboy_and_watergirl/overlays/waiting_player.dart';
import 'package:fireboy_and_watergirl/overlays/main_menu.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';

final gameInstance = FireBoyAndWaterGirlGame();
final gameWidgetKey = GlobalKey<RiverpodAwareGameWidgetState>();

void main() {
  runApp(ProviderScope(
    child: MaterialApp(
      home: RiverpodAwareGameWidget(
        key: gameWidgetKey,
        game: gameInstance,
        overlayBuilderMap: {
          MainMenuOverlay.pathRoute: (context, game) => const MainMenuOverlay(),
          LobbyMenuOverlay.pathRoute: (context, game) => const LobbyMenuOverlay(),
          WaitingPlayerOverlay.pathRoute: (context, game) => const WaitingPlayerOverlay(),
        },
        initialActiveOverlays: const [MainMenuOverlay.pathRoute],
      ),
    ),
  ));
}