import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/game_model.dart';

final providerGameStart = AsyncNotifierProvider<GameNotifier, GameStartModel>(GameNotifier.new);

class GameNotifier extends AsyncNotifier<GameStartModel> {
  @override
  Future<GameStartModel> build() {
    final socketRepository = ref.read(providerSocketRepository);
    socketRepository.on('gameStart', (gameJson) {
      debugPrint('GameStart: $gameJson');
      state = const AsyncLoading();
      if( gameJson is! Map<String, dynamic> ) return;
      state = AsyncData(GameStartModel.fromGameStartJson(gameJson));
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