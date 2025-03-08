import 'package:fireboy_and_watergirl/config/sockets/models/player.dart';

class GameStartModel {
  String lobbyId;
  List<PlayerModel> players;

  GameStartModel({
    required this.lobbyId, 
    required this.players
  });

  factory GameStartModel.fromJson(Map<String, dynamic> json) {
    return GameStartModel(
      lobbyId: json['lobbyId'],
      players: (json['players'] as List).map((p) => PlayerModel.fromGameJson(p)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lobbyId': lobbyId,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }
}