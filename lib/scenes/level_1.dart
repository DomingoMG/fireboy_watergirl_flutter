import 'package:flutter/widgets.dart' show Curves;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:fireboy_and_watergirl/misc/misc.dart';
import 'package:fireboy_and_watergirl/overlays/main_menu.dart';
import 'package:fireboy_and_watergirl/config/audio/audio_manager.dart';
import 'package:fireboy_and_watergirl/fireboy_and_watergirl_game.dart';
import 'package:fireboy_and_watergirl/config/enums/audio_type.dart';

class LevelOneSprite extends SpriteComponent with HasGameReference<FireBoyAndWaterGirlGame> {

  bool playSoundComplete = false;
  bool levelComplete = false;
  bool isFireboyAtDoor = false;
  bool isWaterGirlAtDoor = false;

  final List<PositionComponent> _platforms = [
    FloorHitbox(
      position: Vector2(0, 0),
      size: Vector2(25, 720),
    ),
    FloorHitbox(
      position: Vector2(1255, 0),
      size: Vector2(25, 720),
    ),    
    FloorHitbox(
      position: Vector2(33.19, 598), 
      size: Vector2(392.6, 21.6),
    ),
    FloorHitbox(
      position: Vector2(32, 697), 
      size: Vector2(560, 20),
    ),
    LavaPoolHitbox(
      position: Vector2(672.98, 703), 
      size: Vector2(161.6, 115.99),
    ),
    FloorHitbox(
      position: Vector2(750, 697), 
      size: Vector2(106, 20),
    ),
    WaterPoolHitbox(
      position: Vector2(937.0, 703), 
      size: Vector2(161.6, 115.99),
    ),
    FloorHitbox(
      position: Vector2(1020, 697), 
      size: Vector2(130, 20),
    ),
    FloorHitbox(
      position: Vector2(1197.19, 621.8), 
      size: Vector2(82.4, 97),
    ),
    DiagonalFloorHitbox(
      position: Vector2(1151.8, 621), 
      size: Vector2(40.59, 40.6),
    ),
    FloorHitbox(
      position: Vector2(1150.8, 652.39), 
      size: Vector2(20, 65),
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(1070, 548), 
      size: Vector2(28, 28),
    ),
    FloorHitbox(
      position: Vector2(950, 548), 
      size: Vector2(120, 20),
    ),
    AcidPoolHitbox(
      position: Vector2(869.19, 554.8), 
      size: Vector2(161.6, 115.99),
    ),
    FloorHitbox(
      position: Vector2(623.19, 547.99), 
      size: Vector2(165.59, 20.80),
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(546.60, 498.39), 
      size: Vector2(85, 70),
    ),
    FloorHitbox( 
      position: Vector2(32.39, 498.39), 
      size: Vector2(525.0, 20),
    ),
    FanHitbox(
      maxHeight: 390,
      minHeight: 478,
      position: Vector2(70.39, 478.98),
      size: Vector2(44, 20)
    ),
    FloorHitbox( 
      position: Vector2(166.39, 375.19), 
      size: Vector2(490.4, 20),
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(657, 378),
      size: Vector2(40.59, 40.6)
    ),
    FloorHitbox(
      position: Vector2(692.6, 400.7),
      size: Vector2(560, 20)
    ),
    FanHitbox(
      maxHeight: 300,
      minHeight: 478,
      position: Vector2(1164.37, 391.22),
      size: Vector2(44, 20)
    ),
    FloorHitbox(
      position: Vector2(851.36, 277.69),
      size: Vector2(261.82, 20)
    ),
    FloorHitbox(
      position: Vector2(850.024, 298.24),
      size: Vector2(262.78, 22.68)
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(848.96, 227.07),
      size: Vector2(95.06, 72.95)
    ),
    FloorHitbox(
      position: Vector2(627.47, 226.79),
      size: Vector2(228.62, 67.27)
    ),
    FloorHitbox(
      position: Vector2(28.16, 274.17),
      size: Vector2(600, 20)
    ),
    FanHitbox(
      maxHeight: 189,
      minHeight: 276,
      position: Vector2(209.64, 260.06),
      size: Vector2(44, 20)
    ),
    FloorHitbox(
      position: Vector2(28.31, 176.87),
      size: Vector2(165.94, 98.67)
    ),
    DiagonalFloorHitbox(
      position: Vector2(297.77, 99.6),
      size: Vector2(40.59, 30.6)
    ),
    FloorHitbox(
      position: Vector2(337.79, 99.6),
      size: Vector2(58.77, 20)
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(386.583, 99.6),
      size: Vector2(36.94, 28.41)
    ),
    FloorHitbox(
      position: Vector2(424.83, 127.46),
      size: Vector2(35, 20)
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(458.93, 129.68),
      size: Vector2(36.94, 28.41)
    ),
    FloorHitbox(
      position: Vector2(497.34, 152.29),
      size: Vector2(780.34, 20)
    ),
    FloorHitbox(
      position: Vector2(364.97, 152.29),
      size: Vector2(156.96, 67.10)
    ),
    DiagonalFloorHitbox(
      position: Vector2(852.35, 127.10),
      size: Vector2(40.59, 30.6)
    ),
    FloorHitbox(
      position: Vector2(892.36, 127.10),
      size: Vector2(86.90, 20)
    ),
    DiagonalFloorHitbox(
      diagonalLeftStart: false,
      position: Vector2(979.03, 127.10),
      size: Vector2(40.59, 30.6)
    ),
    FloorHitbox(
      position: Vector2(25.24, 1.48),
      size: Vector2(1230.34, 20)
    ),
  ];


  final List<PositionComponent> _diamonds = [
    for( int i = 2; i < 22; i++ ) 
      DiamondHitbox(
        position: Vector2(i * 50 + 10, i == 13 || i == 18 ? 620 : 650),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),

    for( int i = 1; i < 2; i++ ) 
      DiamondHitbox(
        position: Vector2(i * 50 + 10, 548),
        size: Vector2(50, 50),
        diamondType: 'green'
      ),

    for( int i = 0; i < 8; i++ ) 
      DiamondHitbox(
        position: Vector2(180 + (i*40), 450),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),
    
    for( int i = 0; i < 4; i++ )
      DiamondHitbox(
        position: Vector2(68, 300 + (i*40)),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),


    for( int i = 0; i < 10; i++ )
      DiamondHitbox(
        position: Vector2(180 + (i*40), 330),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),

    for( int i = 0; i < 14; i++ )
      DiamondHitbox(
        position: Vector2(650 + (i*40), 340),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),


    for( int i = 0; i < 5; i++ )
      DiamondHitbox(
        position: Vector2(920 + (i*40), 220),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),


    for( int i = 0; i < 8; i++ )
      DiamondHitbox(
        position: Vector2(300 + (i*40), 225),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),


    for( int i = 0; i < 3; i++ )
      DiamondHitbox(
        position: Vector2(212, 100 + (i*40)),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),

    
    for( int i = 0; i < 4; i++ )
      DiamondHitbox(
        position: Vector2(32 + (i*40), 125),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),

    for( int i = 0; i < 10; i++ )
      DiamondHitbox(
        position: Vector2(470 + (i*40), 100),
        size: Vector2(50, 50),
        diamondType: i % 2 == 0 ? 'red' : 'blue'
      ),
  ];

  final List<PositionComponent> _doors = [
    DoorHitbox(
      doorType: 'red',
      position: Vector2(1162.49, 75),
      size: Vector2(62.50, 81.25),
    ),
    DoorHitbox(
      doorType: 'blue',
      position: Vector2(1095, 75),
      size: Vector2(62.50, 81.25),
    ),
  ];

  final List<PositionComponent> _boxes = [
    BoxHitbox(
      position: Vector2(998, 514),
      size: Vector2(45, 45),
    ),
  ];

  @override
  Future<void> onLoad() async {
    final backgroundImage = await Flame.images.load('levels/level_1.png');
    sprite = Sprite(backgroundImage); 
    size = Vector2(1280, 720);    

    
    for ( final platform in _platforms ) {
      await add(platform);
    }

    for ( final diamond in _diamonds ) {
      await add(diamond);
    }

    for ( final door in _doors ) {
      await add(door);
    }

    for ( final box in _boxes ) {
      await add(box);
    }
  }

  @override
  Future<void> update(double dt) async {
    if (isFireboyAtDoor && isWaterGirlAtDoor && !playSoundComplete) {
      playSoundComplete = true;
      game.fireBoy?.finishLevel();
      game.waterGirl?.finishLevel();
      AudioManager.stopMusicLevel();
      AudioManager.playSound(AudioType.levelComplete);
      levelComplete = true;

      // **Animación de Zoom**
      game.camera.viewfinder.add(
        ScaleEffect.to(
          Vector2(4.5, 4.5), // Zoom x4.5
          EffectController(duration: 4, curve: Curves.easeOut),
          onComplete: () {
            game.overlays.add(MainMenuOverlay.pathRoute);
            game.fireBoy?.resetPosition();
            game.waterGirl?.resetPosition();
          }
        ),
      );
    }
    super.update(dt);
  }

  /// [disposeLevel] is used to remove all the components of the level
  void disposeLevel() {
    removeAll(children);
    removeFromParent();
  }
}