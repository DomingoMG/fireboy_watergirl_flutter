import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/overlays/lobby_menu.dart';
import 'package:fireboy_and_watergirl/overlays/widgets/lobby_item_widget.dart';
import 'package:fireboy_and_watergirl/providers/lobby_provider.dart';

class LobbyBuilders extends ConsumerWidget {
  const LobbyBuilders({
    super.key,
    required this.game,
  });
  final FireBoyAndWaterGirlGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(providerLobbies).when(
      data: (lobbies) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: lobbies.isEmpty ? 
          const Text('No lobbies available', style: TextStyle(fontSize: 24, color: Colors.white))
          : Column(
            children: [
              Expanded(
                child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: lobbies.length,
                itemBuilder: (context, index) => LobbyItemWidget(
                  lobby: lobbies[index],
                  onTap: () {
                    AudioManager.stopPlayIntroMusic();
                    game.overlays.remove(LobbyMenuOverlay.pathRoute);
                    game.startGame();
                  },
                )),
              ),
            ],
          )
      ), 
      error: (error, stackTrace) => Text('Unexpected error: $error'),
      loading: () => const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}