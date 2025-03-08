class PlayerModel {
  String id;
  String name;

  PlayerModel({required this.id, required this.name});

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory PlayerModel.fromGameJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['socketId'],
      name: json['playerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}