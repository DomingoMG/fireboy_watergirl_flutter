class PlayerModel {
  String id;
  String name;
  String? character;

  PlayerModel({
    required this.id, 
    required this.name,
    required this.character
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      name: json['name'],
      character: json['character'],
    );
  }

  factory PlayerModel.fromGameJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['socketId'],
      name: json['playerId'],
      character: json['character'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}