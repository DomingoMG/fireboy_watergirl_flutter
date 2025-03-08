import 'package:flutter/material.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';
import 'package:fireboy_and_watergirl/config/sockets/models/lobby.dart';

class LobbyItemWidget extends StatelessWidget {
  const LobbyItemWidget({
    super.key,
    required this.lobby,
    this.onTap
  });
  final LobbyModel lobby;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onHover: ( event) {
          switch( event ){
            case true:
              AudioManager.playSound(AudioType.buttonHover);
            default:break;
          }
        },
        onTap: () {
          AudioManager.playSound(AudioType.buttonClick);
          onTap?.call();
        },
        child: IgnorePointer(
          child: ListTile(
            leading: Image.asset('assets/images/logo/fireboy_watergirl_logo.png', width: 40, height: 40),
            title: Text(lobby.lobbyId, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(lobby.players.map((p) => p.name).join(', '), style: const TextStyle(fontSize: 16, color: Colors.white)),
            trailing: const Icon(Icons.arrow_right_sharp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}