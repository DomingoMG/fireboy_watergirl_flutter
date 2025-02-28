import 'dart:async';
import 'package:fireboy_and_watergirl/characters/watergirl/watergirl.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fireboy_and_watergirl/characters/fireboy/fireboy.dart';
import 'package:fireboy_and_watergirl/scenes/level_1.dart';
import 'package:fireboy_and_watergirl/backgrounds/background.dart';
import 'package:fireboy_and_watergirl/config/config.dart';

void main() {
  runApp(GameWidget(
    game: FireBoyAndWaterGirlGame(),
  ));
}

class FireBoyAndWaterGirlGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late FireboyAnimation fireBoy;  
  late WaterGirlAnimation waterGirl;

  double baseZoom = 1.5;  // Zoom base
  double minZoom = 1.0;  // Zoom mínimo permitido
  double maxZoom = 2.5;  // Zoom máximo permitido
  double maxDistance = 600; // Distancia máxima entre personajes antes de hacer zoom out

  @override
  Future<void> onLoad() async {
    // debugMode = kDebugMode;
    final world = FireboyAndWaterGirlWorld();
    await AudioManager.init();
    AudioManager.playMusicLevel();

    // Configuración de la cámara
    camera = CameraComponent(
      world: world,
      viewport: MaxViewport(),
    );

    await addAll([world, camera]);

    // Inicialización de personajes y objetos
    final background = BackgroundOneSprite();
    final level = LevelOneSprite();
    fireBoy = FireboyAnimation();
    waterGirl = WaterGirlAnimation();

    await world.addAll([
      background,
      level,
      fireBoy,
      waterGirl,
    ]);

    // La cámara sigue a FireBoy
    camera.follow(fireBoy, maxSpeed: 300);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Ajustar el zoom según la distancia entre FireBoy y WaterGirl
    // final distance = (fireBoy.position - waterGirl.position).length;
    // final zoomFactor = (1 - (distance / maxDistance)).clamp(0.0, 1.0);

    // camera.viewfinder.zoom =
    //     (minZoom + (baseZoom - minZoom) * zoomFactor).clamp(minZoom, maxZoom);

    camera.viewfinder.zoom = 2.5;
    camera.follow(fireBoy);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    fireBoy.onKeyEvent(event, keysPressed);
    waterGirl.onKeyEvent(event, keysPressed);
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


