

import 'package:fireboy_and_watergirl/main.dart';
import 'package:fireboy_and_watergirl/providers/game_provider.dart';
import 'package:fireboy_and_watergirl/providers/lobby_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerGameOnlineState = NotifierProvider<GameStateNotifier, void>(GameStateNotifier.new);

class GameStateNotifier extends Notifier<void> {
  @override
  void build() {
    ref.listen(providerGameStart, (previous, next) {
      final prevValue = previous?.value;
      final nextValue = next.value;
      final lobbyController = ref.read(providerLobbies.notifier);
      if( prevValue?.isGameStarted == true && nextValue?.isGameStarted == false ){
        lobbyController.deleteLobby(prevValue!);
        gameInstance.fireBoy?.resetPosition();
        gameInstance.waterGirl?.resetPosition();
      }
    });
    return ;
  }
}