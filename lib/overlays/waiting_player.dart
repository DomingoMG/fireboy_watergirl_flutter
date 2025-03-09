import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fireboy_and_watergirl/main.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/game_model.dart';
import 'package:fireboy_and_watergirl/overlays/lobby_menu.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';
import 'package:fireboy_and_watergirl/providers/game_provider.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/player.dart';
import 'package:fireboy_and_watergirl/providers/counter_provider.dart';

class WaitingPlayerOverlay extends ConsumerWidget {
  const WaitingPlayerOverlay({
    super.key
  });

  static const String pathRoute = '/waiting-player';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(providerGameStart, (previous, next) {
      final gameStart = next.value;
      if( gameStart is GameStartModel ){
        if( gameStart.isGameStarted ) {
          debugPrint('Start Game Here');   
          // gameInstance.overlays.remove(WaitingPlayerOverlay.pathRoute);
          // gameInstance.startGame();
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            return ref.watch(providerGameStart).when(
              data: ( gameStart ) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: gameStart.players.length == 2 
                    ? const VersusScreen() 
                    : const WaitingVersusScreen(),
                );
              },
              error: (error, stackTrace) => const LobbyClosedScreen(),
              loading: () => const Center(child: CircularProgressIndicator())
            );
          },
        ),
      ),
    );
  }
}

class LobbyClosedScreen extends ConsumerWidget {
  const LobbyClosedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🚨 Animación de Advertencia
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: const Icon(
                        Icons.cloud_off_sharp,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Gap(24),
          
                // ❌ Texto de Advertencia
                const Text(
                  "The lobby has been closed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'custom_font',
                  ),
                ),
                const Gap(16),
          
                // 💬 Explicación breve
                const Text(
                  "The host has closed the lobby. Please go back and find another match.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white60,
                  ),
                ),
                const Gap(32)
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                gameInstance.overlays.remove(WaitingPlayerOverlay.pathRoute);
                gameInstance.overlays.add(LobbyMenuOverlay.pathRoute);
              },
              child: const Text(
                "Find a new match",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WaitingVersusScreen extends ConsumerWidget {
  const WaitingVersusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStart = ref.watch(providerGameStart).value;
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
                      Clipboard.setData(ClipboardData(text: gameStart?.lobbyId ?? ''));
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
                          '${gameStart?.lobbyId}'.toUpperCase(),
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
                  backgroundColor: Colors.red.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final socketRepository = ref.read(providerSocketRepository);
                  if(  gameStart is! GameStartModel ) return;
                  if( gameStart.lobbyId.isNotEmpty && gameStart.players.isNotEmpty ) {
                    socketRepository.emit('deleteLobby', {
                      'lobbyId': gameStart.lobbyId, 
                      'playerId': gameStart.players.first.id
                    });
                  }
                  gameInstance.overlays.remove(WaitingPlayerOverlay.pathRoute);
                  gameInstance.overlays.add(LobbyMenuOverlay.pathRoute);
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                label: const Text(
                  "Close lobby",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ), 
        ),
      ],
    );
  }
}


class VersusScreen extends ConsumerStatefulWidget {
  const VersusScreen({super.key});

  @override
  ConsumerState<VersusScreen> createState() => _VersusScreenState();
}

class _VersusScreenState extends ConsumerState<VersusScreen> {

  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), _onStartGame);
    super.initState();
  }

  void _onStartGame( Timer timer ) {
    if( _timer == null ) return;
    final count = ref.read(providerCounter);
    final countController = ref.read(providerCounter.notifier);
    if( count == 0 ) {
      _timer?.cancel();
      timer.cancel();
      _timer = null;
      gameInstance.overlays.remove(WaitingPlayerOverlay.pathRoute);
      gameInstance.startGame();
      return;
    }
    AudioManager.playSound(AudioType.buttonClick);
    countController.decrement();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameStart = ref.watch(providerGameStart).value;
    final players = gameStart?.players;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlayerVersusView(
                    player: players?.first,
                  ),
                  PlayerVersusView(
                    player: players?.last,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Consumer(
                builder: (context, ref, child) {
                  final count = ref.watch(providerCounter);
                  return Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.redAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PlayerVersusView extends ConsumerWidget {
  const PlayerVersusView({
    super.key,
    required this.player,
  });
  final PlayerModel? player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if( player == null ) return const SizedBox();
    return Column(
      children: [
        Image.asset(
          'assets/images/characters/${player?.character}.png',
          width: 120,
          height: 120,
        ),
        const SizedBox(height: 10),
        Text(
          player?.name ?? '',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}