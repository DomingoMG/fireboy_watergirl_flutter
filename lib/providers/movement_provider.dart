import 'package:fireboy_and_watergirl/providers/game_provider.dart';
import 'package:fireboy_and_watergirl/providers/player_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/player_movement.dart';

final providerPlayerMovement = NotifierProvider<PlayerMovementNotifier, PlayerMoveModel>(
  PlayerMovementNotifier.new
);

class PlayerMovementNotifier extends Notifier<PlayerMoveModel> {
  @override
  PlayerMoveModel build() {
    final socketRepository = ref.read(providerSocketRepository);
    final gameOnline = ref.read(providerGameStart).value;

    socketRepository.on('updatePlayer', (updatePlayerJson) {
      final playerMove = PlayerMoveModel.fromJson(updatePlayerJson);

      debugPrint('✅ Se ha movido el jugador ${playerMove.playerId} a la posición ${playerMove.position.x}, ${playerMove.position.y}');

      // 🔥 Usamos `copyWith` para actualizar solo valores nuevos
      state = state.copyWith(
        character: playerMove.character,
        playerId: playerMove.playerId,
        lobbyId: gameOnline?.lobbyId ?? '',
        action: playerMove.action,
        position: playerMove.position,
      );
    });

    return PlayerMoveModel(
      playerId: '',
      lobbyId: '',
      character: '',
      action: PlayerMovementAction.idle,
      position: PlayerPositionModel(x: 0, y: 0),
    );
  }

  // ✅ Método para enviar movimiento al servidor
  void sendMove(PlayerMovementAction action, double x, double y) {
    final gameStart = ref.read(providerGameStart).value;
    if( gameStart?.isOnline == false) return;
    
    final socketRepository = ref.read(providerSocketRepository);
    final player = ref.read(providerPlayer);
    final movement = PlayerMoveModel(
      character: player.character ?? state.character,
      playerId: player.id,
      lobbyId: gameStart!.lobbyId,
      action: action,
      position: PlayerPositionModel(x: x, y: y),
    );

    socketRepository.emit('playerMove', movement.toJson());

    debugPrint("🎮 Enviando movimiento: ${movement.toJson()}");
  }
}
