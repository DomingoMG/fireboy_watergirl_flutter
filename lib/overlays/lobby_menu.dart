import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/overlays/waiting_player.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/overlays/builders/lobby_builders.dart';
import 'package:fireboy_and_watergirl/providers/lobby_provider.dart';
import 'package:fireboy_and_watergirl/overlays/main_menu.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';

class LobbyMenuOverlay extends ConsumerStatefulWidget {
  const LobbyMenuOverlay({
    super.key,
    required this.game,
  });
  final FireBoyAndWaterGirlGame game;
  static const String pathRoute = '/lobby-menu';

  @override
  ConsumerState<LobbyMenuOverlay> createState() => _LobbyMenuState();
}

class _LobbyMenuState extends ConsumerState<LobbyMenuOverlay> {

  @override
  void initState() {
    ref.read(providerLobbies.notifier).findLobbies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lobbyController = ref.read(providerLobbies.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            AudioManager.playSound(AudioType.buttonClick);
            await Future.delayed(const Duration(seconds: 1));
            lobbyController.findLobbies();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () {
                    AudioManager.playSound(AudioType.buttonClick);
                    widget.game.overlays.remove(LobbyMenuOverlay.pathRoute);
                    widget.game.overlays.add(MainMenuOverlay.pathRoute);
                  }
                ),
                title: const Text('Lobbies available', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'custom_font',
                  ),
                ),
                backgroundColor: Colors.black,
                elevation: 0,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () async {
                      AudioManager.playSound(AudioType.buttonClick);
                      lobbyController.findLobbies();
                    },
                  )
                ],
              ),
              SliverFillRemaining(child: LobbyBuilders(game: widget.game))
            ],
          ),
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        runSpacing: 4,
        spacing: 12,
        children: [
          FloatingActionButton.extended(
            label: const Text('🎮 Create lobby', style: TextStyle(fontSize: 16)),
            onPressed: () {
              AudioManager.playSound(AudioType.buttonClick);
              lobbyController.createLobby();
              widget.game.overlays.remove(LobbyMenuOverlay.pathRoute);
              widget.game.overlays.add(WaitingPlayerOverlay.pathRoute);
            },
          )
        ],
      ),
    );
  }
}


// ButtonWidget(
//   text: '⟳ Refresh',
//   fontSize: 16,
//   backgroundColor: Colors.white,
//   highlightColor: Colors.grey.shade500,
//   splashColor: Colors.white.withValues(alpha: 0.3),
//   hoverColor: Colors.grey.shade300,
//   fontColor: Colors.black,
//   onPressed: () async {
//     AudioManager.playSound(AudioType.buttonClick);
//     lobbyController.findLobbies();
//   },
// ),
// const Gap(16),
// ButtonWidget(
//   text: '🎮 Create lobby',
//   fontSize: 16,
//   backgroundColor: Colors.white,
//   highlightColor: Colors.grey.shade500,
//   splashColor: Colors.white.withValues(alpha: 0.3),
//   hoverColor: Colors.grey.shade300,
//   fontColor: Colors.black,
//   onPressed: () {

//   },
// ),