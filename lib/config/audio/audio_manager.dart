import 'package:fireboy_and_watergirl/config/config.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    final audioNames = AudioType.values.map((item) => item.assetName).toList();
    await FlameAudio.audioCache.loadAll(audioNames);
    _initialized = true;
  }

  static Future<void> playSound(AudioType audio, {double volume = 1.0, loop = false}) async {
    if( loop ) {
      FlameAudio.loop(audio.assetName);
      return;
    }
    
    await FlameAudio.play(audio.assetName, volume: volume);
  }

  static void playMusicLevel() async {
    await FlameAudio.bgm.play(AudioType.musicLevel.assetName, volume: 0.2);
  }

  static void stopMusicLevel() async {
    await FlameAudio.bgm.stop();
  }

  static void playIntroMusic() async {
    await FlameAudio.bgm.play(AudioType.musicIntro.assetName, volume: 0.2);
  }

  static void stopPlayIntroMusic() async {
    await FlameAudio.bgm.stop();
  }
}
