import 'package:flame_audio/flame_audio.dart';
import 'package:vibration/vibration.dart';

import 'settings_manager.dart';

/// Zıplama, çarpışma ve tap ses efektlerini çalan; ayrıca titreşim
/// tetikleyen singleton. Ses dosyaları assets/audio/ altında.
///
/// NOT: assets/audio/jump.mp3, hit.mp3, tap.mp3 dosyaları şu anda
/// placeholder'dır. Bkz. ASSETS_TODO.md
class AudioManager {
  AudioManager._internal();
  static final AudioManager instance = AudioManager._internal();

  bool _preloaded = false;

  Future<void> preload() async {
    if (_preloaded) return;
    try {
      await FlameAudio.audioCache.loadAll([
        'jump.mp3',
        'hit.mp3',
        'tap.mp3',
      ]);
      _preloaded = true;
    } catch (_) {
      // Assetler henüz eklenmediyse sessizce geç; oyun placeholder'sız
      // da çalışmaya devam etsin.
    }
  }

  void playJump() {
    if (!SettingsManager.instance.soundEnabled) return;
    FlameAudio.play('jump.mp3', volume: 0.6);
  }

  void playHit() {
    if (!SettingsManager.instance.soundEnabled) return;
    FlameAudio.play('hit.mp3', volume: 0.8);
  }

  void playTap() {
    if (!SettingsManager.instance.soundEnabled) return;
    FlameAudio.play('tap.mp3', volume: 0.4);
  }

  Future<void> vibrateShort() async {
    if (!SettingsManager.instance.vibrationEnabled) return;
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 40);
    }
  }
}
