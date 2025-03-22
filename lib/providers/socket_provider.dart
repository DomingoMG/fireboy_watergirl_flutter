import 'package:fireboy_and_watergirl/config/sockets/socket_client.dart';
import 'package:fireboy_and_watergirl/providers/player_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerSocketRepository = NotifierProvider<SocketNotifier, SocketClientRepository>(SocketNotifier.new);

class SocketNotifier extends Notifier<SocketClientRepository> {
  @override
  SocketClientRepository build() {
    final playerController = ref.read(providerPlayer.notifier);
    final socket = SocketClientRepository()..connect();
    socket.on('playerConnected', ( playerJson ) {
      debugPrint('✅ Nuevo jugador conectado: ${playerJson['playerId']}');
      playerController.setId = playerJson['playerId'];
    });
    return socket;
  }
}