enum PlayerMovementAction {
  idle,
  moveLeft,
  moveRight,
  jump,
  dead
}

class PlayerMoveModel {
  final String playerId;
  final String lobbyId;
  final String character;
  final PlayerMovementAction action;
  final PlayerPositionModel position;

  PlayerMoveModel({
    required this.playerId,
    required this.lobbyId,
    required this.character,
    required this.action,
    required this.position,
  });

  factory PlayerMoveModel.fromJson(Map<String, dynamic> json) {
    final action = PlayerMovementAction.values.firstWhere(
      (a) => a.name.toLowerCase() == json['action'].toString().toLowerCase(),
      orElse: () => PlayerMovementAction.idle
    );

    return PlayerMoveModel(
      playerId: json['playerId'],
      lobbyId: json['lobbyId'],
      character: json['character'],
      action: action,
      position: PlayerPositionModel.fromJson(json['position']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'character': character,
      'lobbyId': lobbyId,
      'action': action.name,
      'position': position.toJson(),
    };
  }

  // ✅ Método copyWith para actualizar sin perder datos previos
  PlayerMoveModel copyWith({
    String? playerId,
    String? lobbyId,
    String? character,
    PlayerMovementAction? action,
    PlayerPositionModel? position,
  }) {
    return PlayerMoveModel(
      character: character ?? this.character,
      playerId: playerId ?? this.playerId,
      lobbyId: lobbyId ?? this.lobbyId,
      action: action ?? this.action,
      position: position ?? this.position,
    );
  }
}

class PlayerPositionModel {
  final double x;
  final double y;

  PlayerPositionModel({
    required this.x,
    required this.y,
  });

  factory PlayerPositionModel.fromJson(Map<String, dynamic> json) {
    return PlayerPositionModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}
