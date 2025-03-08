import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fireboy_and_watergirl/providers/socket_provider.dart';
import 'package:fireboy_and_watergirl/overlays/lobby_menu.dart';
import 'package:fireboy_and_watergirl/overlays/widgets/button_widget.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';

class MainMenuOverlay extends ConsumerStatefulWidget {
  final FireBoyAndWaterGirlGame game;
  static const String pathRoute = '/main-menu';

  const MainMenuOverlay({super.key, required this.game});

  @override
  ConsumerState<MainMenuOverlay> createState() => _MainMenuState();
}

class _MainMenuState extends ConsumerState<MainMenuOverlay> {
  @override
  void initState() {
    ref.read(providerSocketRepository);
    // AudioManager.playIntroMusic();
    super.initState();
  }

  @override
  void dispose() {
    // AudioManager.stopPlayIntroMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlays = widget.game.overlays;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/logo/fireboy_watergirl_logo.png'),
            colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.8), BlendMode.darken),
            fit: BoxFit.fitWidth,
          )
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: [
                        TextSpan(
                          text: 'FireBoy ',
                          style: TextStyle(
                            fontFamily: 'custom_font',
                            color: Colors.red,
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'and ',
                          style: TextStyle(
                            fontFamily: 'custom_font',
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'WaterGirl',
                          style: TextStyle(
                            fontFamily: 'custom_font',
                            color: Colors.blue,
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Created by DomingoMG',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'custom_font',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      constraints:
                          const BoxConstraints(maxWidth: 400, minWidth: 250),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ButtonWidget(
                            text: 'Two Players',
                            backgroundColor: Colors.redAccent.shade700,
                            highlightColor: Colors.red.shade600,
                            splashColor: Colors.white.withValues(alpha: 0.3),
                            hoverColor: Colors.red.shade900,
                            fontColor: Colors.white,
                            onPressed: () {
                              AudioManager.stopPlayIntroMusic();
                              overlays.remove(MainMenuOverlay.pathRoute);
                              widget.game.startGame();
                            },
                          ),
                          const Gap(20),
                          ButtonWidget(
                            text: 'Online',
                            backgroundColor: Colors.white,
                            highlightColor: Colors.grey.shade500,
                            splashColor: Colors.white.withValues(alpha: 0.3),
                            hoverColor: Colors.grey.shade300,
                            fontColor: Colors.black,
                            onPressed: () {
                              overlays
                                ..remove(MainMenuOverlay.pathRoute)
                                ..add(LobbyMenuOverlay.pathRoute);
                            },
                          ),
                          const Gap(20),
                          ButtonWidget(
                            text: 'Exit',
                            backgroundColor: Colors.grey.shade800,
                            highlightColor: Colors.grey.shade600,
                            splashColor: Colors.white.withValues(alpha: 0.3),
                            hoverColor: Colors.grey.shade700,
                            fontColor: Colors.white,
                            onPressed: () {
                              AudioManager.stopPlayIntroMusic();
                              overlays.remove(MainMenuOverlay.pathRoute);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}