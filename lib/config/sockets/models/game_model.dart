import 'package:fireboy_and_watergirl/config/sockets/models/player.dart';

class GameStartModel {
  String lobbyId;
  List<PlayerModel> players;
  bool isOnline;
  bool isGameStarted;

  GameStartModel({
    required this.lobbyId, 
    required this.players,
    this.isGameStarted = false,
    this.isOnline = false
  });

  factory GameStartModel.fromGameStartJson(Map<String, dynamic> json) {
    return GameStartModel(
      lobbyId: json['lobbyId'],
      players: (json['players'] as List).map((p) => PlayerModel.fromJson(p)).toList(),
      isGameStarted: true,
      isOnline: true
    );
  }

  GameStartModel copyWith({
    String? lobbyId,
    List<PlayerModel>? players,
    bool? isGameStarted
  }) {
    return GameStartModel(
      lobbyId: lobbyId ?? this.lobbyId,
      players: players ?? this.players,
      isGameStarted: isGameStarted ?? this.isGameStarted,
      isOnline: isOnline
    );
  }

  factory GameStartModel.fromLobbyCreatedJson(Map<String, dynamic> json) {
    return GameStartModel(
      lobbyId: json['lobbyId'],
      players: (json['players'] as List).map((p) => PlayerModel.fromGameJson(p)).toList(),
      isOnline: true
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lobbyId': lobbyId,
      'players': players.map((p) => p.toJson()).toList(),
      'isGameStarted': isGameStarted,
      'isOnline': isOnline
    };
  }
}