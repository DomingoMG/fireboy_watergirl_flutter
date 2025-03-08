import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/game_model.dart';
import 'package:fireboy_and_watergirl/providers/game_provider.dart';
import 'package:fireboy_and_watergirl/providers/player_provider.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/lobby.dart';

final providerLobbies = AsyncNotifierProvider<LobbyNotifier, List<LobbyModel>>(LobbyNotifier.new);

class LobbyNotifier extends AsyncNotifier<List<LobbyModel>> {
  @override
  List<LobbyModel> build() {
    ref.read(providerGameStart);
    final socketRepository = ref.read(providerSocketRepository);
    socketRepository.on('availableLobbies', (lobbiesJson) async {
      state = const AsyncLoading();
      if( lobbiesJson is! List ) return;
      state = AsyncData(lobbiesJson.map((lobbyJson) {
        if (lobbyJson is! Map<String, dynamic>) return null;
        return LobbyModel.fromJson(lobbyJson);
      }).whereType<LobbyModel>().toList());
    });

    socketRepository.on('lobbyCreated', (data){
      final gameStartController = ref.read(providerGameStart.notifier);
      if( data is! Map<String, dynamic> ) return;
      debugPrint('✅ Nuevo juego creado: $data');
      gameStartController.createLobby(GameStartModel.fromJson(data));
    });

    ref.onDispose(() => _onFindLobbiesDispose());
    return [];
  }

  void findLobbies() {
    debugPrint('⚙️ Buscando lobbies...');
    final socketRepository = ref.read(providerSocketRepository);
    socketRepository.emit('getAvailableLobbies', {});
  }

  void _onFindLobbiesDispose() {
    final socketRepository = ref.read(providerSocketRepository);
    socketRepository.off('availableLobbies');
  }

  void createLobby() {
    debugPrint('⚙️ Creando lobby...');
    final player = ref.read(providerPlayer);
    final socketRepository = ref.read(providerSocketRepository);
    socketRepository.emit('createLobby', {'playerId': player.name});
  }
}