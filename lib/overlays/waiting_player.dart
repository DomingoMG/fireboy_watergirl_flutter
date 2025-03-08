import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fireboy_and_watergirl/overlays/lobby_menu.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/providers/game_provider.dart';

class WaitingPlayerOverlay extends ConsumerWidget { 
  final FireBoyAndWaterGirlGame game;

  const WaitingPlayerOverlay({
    super.key,
    required this.game,
  });

  static const String pathRoute = '/waiting-player';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ref.watch(providerGameStart).when(
        data: ( gameStart ) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Waiting for a Player...",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'custom_font',
                      ),
                    ),
                    const Gap(16),
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    const Gap(16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Tooltip(
                        message: "Copy Lobby Code",
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: gameStart.lobbyId));
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Lobby Code",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white60,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                gameStart.lobbyId.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final socketRepository = ref.read(providerSocketRepository);
                        if( gameStart.lobbyId.isNotEmpty && gameStart.players.isNotEmpty ) {
                          socketRepository.emit('deleteLobby', {
                            'lobbyId': gameStart.lobbyId, 
                            'playerId': gameStart.players.first.id
                          });
                        }
                        game.overlays.remove(WaitingPlayerOverlay.pathRoute);
                        game.overlays.add(LobbyMenuOverlay.pathRoute);
                      },
                      icon: const Icon(Icons.exit_to_app, color: Colors.white),
                      label: const Text(
                        "Exit Lobby",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ), 
              ),
            ],
          );
        },
        error: (error, stackTrace) => Text('Unexpected error: $error'),
        loading: () => const Center(child: CircularProgressIndicator())
      ),
    );
  }
}
