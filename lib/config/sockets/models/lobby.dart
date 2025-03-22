import 'package:fireboy_and_watergirl/config/sockets/models/player.dart';

class LobbyModel {
  final String lobbyId;
  final List<PlayerModel> players;

  LobbyModel({required this.lobbyId, required this.players});

  factory LobbyModel.fromJson(Map<String, dynamic> json) {
    return LobbyModel(
      lobbyId: json['lobbyId'],
      players: (json['players'] as List).map((p) => PlayerModel.fromJson(p)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lobbyId': lobbyId,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }
}
