import 'dart:async';
import 'dart:io';
import 'package:fireboy_and_watergirl/providers/game_provider.dart';
import 'package:fireboy_and_watergirl/providers/player_provider.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fireboy_and_watergirl/misc/jump_button.dart';
import 'package:fireboy_and_watergirl/characters/fireboy/fireboy.dart';
import 'package:fireboy_and_watergirl/characters/watergirl/watergirl.dart';
import 'package:fireboy_and_watergirl/scenes/level_1.dart';
import 'package:fireboy_and_watergirl/backgrounds/background.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';


class FireBoyAndWaterGirlGame extends FlameGame with RiverpodGameMixin, KeyboardEvents, HasCollisionDetection {
  
  late JoystickComponent joystick;  
  late JumpButton jumpButton;
  FireboyAnimation? fireBoy;  
  WaterGirlAnimation? waterGirl;
  LevelOneSprite? level;

  double baseZoom = 1.5;  // Zoom base
  double minZoom = 1.0;  // Minimum permitted zoom
  double maxZoom = 4.5;  // Maximum allowed zoom
  double maxDistance = 2500; // Maximum distance between characters before zoom out

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  Future<void> startGame() async {
    debugMode = kDebugMode;
    await AudioManager.init();
    // AudioManager.playMusicLevel();
    final gameOnline = ref.read(providerGameStart).value;
    final player = ref.read(providerPlayer);
    final world = FireboyAndWaterGirlWorld();
    final background = BackgroundOneSprite();
    
    level = LevelOneSprite();
    fireBoy = FireboyAnimation();
    waterGirl = WaterGirlAnimation();
    camera = CameraComponent(
      world: world,
      viewport: MaxViewport(),
    );
      
    await addAll([world, camera]);

    if( Platform.isAndroid || Platform.isIOS ) {
      await _addJoystick(); 
    }
    await world.addAll([
      background,
      level!,
      fireBoy!,
      waterGirl!
    ]);   


    // The camera follows Fireboy
    if( gameOnline != null ) {
      if(player.character == 'fireboy') {
        camera.follow(fireBoy!, maxSpeed: 300);
        if( Platform.isAndroid || Platform.isIOS ) {
          fireBoy?.joystick = joystick;
        }
      } else {
        camera.follow(waterGirl!, maxSpeed: 300);
        if( Platform.isAndroid || Platform.isIOS ) {
          waterGirl?.joystick = joystick;
        }
      }
    }
  }

  Future<void> _addJoystick() async {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: await loadSprite('joystick/controller_position.png'),
        size: Vector2.all(50),
      ),
      background: SpriteComponent(
        sprite: await loadSprite('joystick/controller_radius.png'),
        size: Vector2.all(100),
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );
    final player = ref.read(providerPlayer);
    final character = player.character == 'fireboy' ? fireBoy! : waterGirl!;
    jumpButton = JumpButton(character);    
    camera.viewport.add(joystick);
    camera.viewport.add(jumpButton);
  }

  

  @override
  void update(double dt) {
    super.update(dt);
    // AudioManager.stopMusicLevel();
    if( level == null ) return;

    if( level is LevelOneSprite ) {
      if( level!.levelComplete ) return;
    }

    // Adjust the zoom according to the distance between FireBoy and Watergirl
    final distance = (fireBoy!.position - waterGirl!.position).length;
    final zoomFactor = (1 - (distance / maxDistance)).clamp(0.0, 1.0);

    camera.viewfinder.zoom =
        (minZoom + (baseZoom - minZoom) * zoomFactor).clamp(minZoom, maxZoom);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final player = ref.read(providerPlayer);
    if( player.character == 'fireboy' ) {
      fireBoy?.onKeyEvent(event, keysPressed);
    } else {
      waterGirl?.onKeyEvent(event, keysPressed);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onDispose() {
    AudioManager.stopMusicLevel();
    AudioManager.stopPlayIntroMusic();
    super.onDispose();
  }
}

class FireboyAndWaterGirlWorld extends World {}


