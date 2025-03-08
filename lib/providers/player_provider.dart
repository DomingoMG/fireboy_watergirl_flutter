
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/player.dart';

final providerPlayer = NotifierProvider<PlayerNotifier, PlayerModel>(PlayerNotifier.new);

class PlayerNotifier extends Notifier<PlayerModel> {
  @override
  PlayerModel build() {
    return PlayerModel(
      id: '',
      name: 'Player 1',
    );
  }

  void setName(String name) {
    state = PlayerModel(
      id: state.id,
      name: name,
    );
  }
  
  void setId(String id) {
    state = PlayerModel(
      id: id,
      name: state.name,
    );
  }
}