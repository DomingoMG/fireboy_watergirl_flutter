
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/player.dart';

final providerPlayer = NotifierProvider<PlayerNotifier, PlayerModel>(PlayerNotifier.new);

class PlayerNotifier extends Notifier<PlayerModel> {
  @override
  PlayerModel build() {
    return PlayerModel(
      id: '',
      name: '',
      character: null,
    );
  }
  
  set setName(String name) => state.name = name;
  String get name => state.name;
  set setId(String id) => state.id = id;

  void generateRandomCharacter() {
    final characterRandom = Random().nextBool() ? 'fireboy' : 'watergirl';
    state.character = characterRandom;
  }
}