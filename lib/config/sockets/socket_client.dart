import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClientRepository {
  static const String host = 'http://192.168.1.12:3000';
  
  // Singleton
  static final SocketClientRepository _instance = SocketClientRepository._internal();
  factory SocketClientRepository() => _instance;
  SocketClientRepository._internal();

  late io.Socket socket;

  void connect() {
    socket = io.io(
      host,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionAttempts(5) // Intentos de reconexión en caso de fallo
          .setReconnectionDelay(1000) // Espera de 1s entre intentos
          .build(),
    );

    socket.onConnect((_) {
      debugPrint('✅ Connected to WebSocket server');
    });

    socket.onDisconnect((_) {
      debugPrint('❌ Disconnected from WebSocket server');
    });

    socket.onError((data) {
      debugPrint('⚠️ Error in WebSocket: $data');
    });

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  // Enviar eventos al servidor
  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  // Escuchar eventos del servidor
  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  // Dejar de escuchar eventos
  void off(String event) {
    socket.off(event);
  }
}
