import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fireboy_and_watergirl/providers/player_provider.dart';

class NicknameDialog extends ConsumerWidget {
  const NicknameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return AlertDialog(
      title: const Text('Nickname', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: const Color.fromARGB(255, 7, 7, 7),
      content: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          const Text('Please enter your nickname:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          TextFormField(
            initialValue: 'Player',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: ( value  ) {
              if( value!.isEmpty ) return 'Please enter a nickname';
              // Regex only text and numbers
              if( !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value) ) return 'Only text and numbers';
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nickname',
              labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onChanged: ( value ) => ref.read(providerPlayer.notifier).setName = value
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}