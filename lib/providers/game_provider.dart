import 'package:fireboy_and_watergirl/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/game_model.dart';

final providerGameStart = AsyncNotifierProvider<GameNotifier, GameStartModel>(GameNotifier.new);

class GameNotifier extends AsyncNotifier<GameStartModel> {
  @override
  Future<GameStartModel> build() {
    final socketRepository = ref.read(providerSocketRepository);
    final player = ref.read(providerPlayer);
    socketRepository.on('gameStart', (gameJson) {
      debugPrint('GameStart: $gameJson');
      state = const AsyncLoading();
      if( gameJson is! Map<String, dynamic> ) return;
      final gameModel = GameStartModel.fromGameStartJson(gameJson);
      final playerFound = gameModel.players.firstWhere((p) => p.id == player.id);
      player.character = playerFound.character;
      state = AsyncData( gameModel );
    });

    socketRepository.on('playerLeft', ( playerLeftJson ) {
      debugPrint('✅ Jugador ${playerLeftJson['playerId']} ha abandonado el juego');
      final gameStart = state.value?.copyWith(
        players: state.value?.players.where((player) => player.name != playerLeftJson['playerId']).toList() ?? [],
        isGameStarted: false
      );
      state = const AsyncLoading();
      if( gameStart is! GameStartModel ) return;
      debugPrint('✅ Nuevo juego creado: ${gameStart.players.map((p) => p.toJson()).toList()} jugadores');
      state = AsyncData(gameStart);
    });


    socketRepository.on('lobbyClosed', ( lobbyClosedJson ) {
      debugPrint('✅ Lobby ${lobbyClosedJson['lobbyId']} ha sido cerrado');
      state = AsyncError('The lobby has been closed by the host', StackTrace.current);
    });

    ref.onDispose(() => socketRepository.off('gameStart'));
    return Future.value(GameStartModel(
      lobbyId: '', 
      players: []
    ));
  }

  void createLobby( GameStartModel gameStart ) {
    state = const AsyncLoading();
    state = AsyncData(gameStart);
  }
}