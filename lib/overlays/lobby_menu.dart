import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fireboy_and_watergirl/overlays/waiting_player.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/overlays/builders/lobby_builders.dart';
import 'package:fireboy_and_watergirl/providers/lobby_provider.dart';
import 'package:fireboy_and_watergirl/overlays/main_menu.dart';
import 'package:fireboy_and_watergirl/overlays/widgets/button_widget.dart';
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
                ButtonWidget(
                  text: '⟳ Refresh',
                  fontSize: 16,
                  backgroundColor: Colors.white,
                  highlightColor: Colors.grey.shade500,
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  hoverColor: Colors.grey.shade300,
                  fontColor: Colors.black,
                  onPressed: () async {
                    AudioManager.playSound(AudioType.buttonClick);
                    lobbyController.findLobbies();
                  },
                ),
                const Gap(16),
                ButtonWidget(
                  text: '🎮 Create lobby',
                  fontSize: 16,
                  backgroundColor: Colors.white,
                  highlightColor: Colors.grey.shade500,
                  splashColor: Colors.white.withValues(alpha: 0.3),
                  hoverColor: Colors.grey.shade300,
                  fontColor: Colors.black,
                  onPressed: () {
                    AudioManager.playSound(AudioType.buttonClick);
                    lobbyController.createLobby();
                    widget.game.overlays.remove(LobbyMenuOverlay.pathRoute);
                    widget.game.overlays.add(WaitingPlayerOverlay.pathRoute);
                  },
                ),
              ],
            ),
            SliverFillRemaining(child: LobbyBuilders(game: widget.game))
          ],
        ),
      ),
    );
  }
}