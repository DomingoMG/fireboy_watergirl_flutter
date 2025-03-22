import 'package:fireboy_and_watergirl/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/overlays/waiting_player.dart';
import 'package:fireboy_and_watergirl/overlays/builders/lobby_builders.dart';
import 'package:fireboy_and_watergirl/providers/lobby_provider.dart';
import 'package:fireboy_and_watergirl/overlays/main_menu.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';

class LobbyMenuOverlay extends ConsumerStatefulWidget {
  const LobbyMenuOverlay({
    super.key
  });
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
          edgeOffset: 60,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: Colors.white,
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
                    gameInstance.overlays.remove(LobbyMenuOverlay.pathRoute);
                    gameInstance.overlays.add(MainMenuOverlay.pathRoute);
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
                pinned: true
              ),
              const LobbyBuilders()
            ],
          ),
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.spaceEvenly,
        spacing: 16,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.white,
            label: const Text('🔍 Find lobbies', style: TextStyle(fontSize: 16, color: Colors.black)),
            onPressed: () {
              AudioManager.playSound(AudioType.buttonClick);
              lobbyController.findLobbies();
            },
          ),
          FloatingActionButton.extended(
            backgroundColor: Colors.red.shade900,
            label: const Text('🎮 Create lobby', style: TextStyle(fontSize: 16, color: Colors.white)),
            onPressed: () {
              AudioManager.playSound(AudioType.buttonClick);
              lobbyController.createLobby();
              gameInstance.overlays.remove(LobbyMenuOverlay.pathRoute);
              gameInstance.overlays.add(WaitingPlayerOverlay.pathRoute);
            },
          )
        ],
      ),
    );
  }
}