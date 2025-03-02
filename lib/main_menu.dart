import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';

class MainMenu extends StatefulWidget {
  final FireBoyAndWaterGirlGame game;
  static const String pathRoute = '/main-menu';

  const MainMenu({super.key, required this.game});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    AudioManager.playIntroMusic();
    super.initState();
  }

  @override
  void dispose() {
    AudioManager.stopPlayIntroMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
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
                        _ButtonWidget(
                          text: 'Play',
                          backgroundColor: Colors.redAccent.shade700,
                          highlightColor: Colors.red.shade600,
                          splashColor: Colors.white.withValues(alpha: 0.3),
                          hoverColor: Colors.red.shade900,
                          fontColor: Colors.white,
                          onPressed: () {
                            widget.game.overlays.remove(MainMenu.pathRoute);
                            AudioManager.stopPlayIntroMusic();
                            widget.game.startGame();
                          },
                        ),
                        const Gap(20),
                        _ButtonWidget(
                          text: 'Settings',
                          backgroundColor: Colors.white,
                          highlightColor: Colors.grey.shade500,
                          splashColor: Colors.white.withValues(alpha: 0.3),
                          hoverColor: Colors.grey.shade300,
                          fontColor: Colors.black,
                          onPressed: () {
                            widget.game.overlays.remove(MainMenu.pathRoute);
                          },
                        ),
                        const Gap(20),
                        _ButtonWidget(
                          text: 'Exit',
                          backgroundColor: Colors.grey.shade800,
                          highlightColor: Colors.grey.shade600,
                          splashColor: Colors.white.withValues(alpha: 0.3),
                          hoverColor: Colors.grey.shade700,
                          fontColor: Colors.white,
                          onPressed: () {
                            widget.game.overlays.remove(MainMenu.pathRoute);
                            AudioManager.stopPlayIntroMusic();
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
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget({
    required this.backgroundColor,
    required this.text,
    required this.fontColor,
    required this.onPressed,
    required this.splashColor,
    required this.highlightColor,
    required this.hoverColor,
  });
  final String text;
  final Color backgroundColor;
  final Color fontColor;
  final VoidCallback onPressed;
  final Color splashColor;
  final Color highlightColor;
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => AudioManager.playSound(AudioType.buttonHover),
      child: MaterialButton(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(16),
        onPressed: onPressed,
        elevation: 5, 
        highlightColor: highlightColor, 
        splashColor: splashColor,
        hoverColor: hoverColor,
        child: Text(text,
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'custom_font',
                color: fontColor,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
