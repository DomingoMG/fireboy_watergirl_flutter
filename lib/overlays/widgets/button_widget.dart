import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart' show AudioManager;
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.fontColor,
    required this.onPressed,
    required this.splashColor,
    required this.highlightColor,
    required this.hoverColor,
    this.fontSize = 24,
    this.fontFamily = 'custom_font',
  });
  final String text;
  final Color backgroundColor;
  final Color fontColor;
  final VoidCallback onPressed;
  final Color splashColor;
  final Color highlightColor;
  final Color hoverColor;
  final double fontSize;
  final String fontFamily;

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
                fontSize: fontSize,
                fontFamily: fontFamily,
                color: fontColor,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
