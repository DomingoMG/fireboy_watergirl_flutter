import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/overlays/lobby_menu.dart';
import 'package:fireboy_and_watergirl/main.dart';
import 'package:fireboy_and_watergirl/overlays/widgets/lobby_item_widget.dart';
import 'package:fireboy_and_watergirl/providers/lobby_provider.dart';
import 'package:fireboy_and_watergirl/overlays/waiting_player.dart';
import 'package:fireboy_and_watergirl/providers/game_provider.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';

class LobbyBuilders extends ConsumerWidget {
  const LobbyBuilders({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(providerLobbies);

    return state.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
      error: (error, stackTrace) => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Unexpected error: $error',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      ),
      data: (lobbies) {
        if (lobbies.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No lobbies available',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => LobbyItemWidget(
              lobby: lobbies[index],
              onTap: () {
                ref.read(providerGameStart);
                final socketRepository = ref.read(providerSocketRepository);
                AudioManager.stopPlayIntroMusic();
                gameInstance.overlays.remove(LobbyMenuOverlay.pathRoute);
                gameInstance.overlays.add(WaitingPlayerOverlay.pathRoute);
                socketRepository.emit('joinSpecificLobby', {'lobbyId': lobbies[index].lobbyId, 'playerId': 'Yekale'});
              },
            ),
            childCount: lobbies.length,
          ),
        );
      },
    );
  }
}
