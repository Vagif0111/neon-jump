import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/obstacle_spawner.dart';
import 'components/player.dart';
import 'components/scrolling_background.dart';
import 'managers/audio_manager.dart';
import 'managers/storage_manager.dart';

/// Neon Jump'ın ana oyun sınıfı.
///
/// Sorumlulukları:
/// - Oyun döngüsünü (update/render) yönetmek
/// - Zorluk seviyesini (koşu hızı) zamanla artırmak
/// - Skoru takip etmek ve HUD'a bildirmek
/// - Tap girdisini oyuncuya iletmek
/// - Oyun bitişini / duraklatmayı yönetmek
class NeonJumpGame extends FlameGame
    with HasCollisionDetection, TapDetector, PanDetector {
  NeonJumpGame({
    required this.onScoreChanged,
    required this.onGameOver,
  });

  /// HUD'u güncellemek için dışarıya bildirilen skor callback'i.
  final void Function(int score) onScoreChanged;

  /// Oyun bittiğinde çağrılan callback (final skoru taşır).
  final void Function(int finalScore) onGameOver;

  // --- Zorluk / hız ayarları ---
  static const double _baseSpeed = 260.0; // px/sn, başlangıç koşu hızı
  static const double _maxSpeed = 620.0; // px/sn, ulaşılabilecek üst sınır
  static const double _speedRampPerSecond = 6.0; // her saniye hız artışı

  double _elapsedSeconds = 0;
  double get worldSpeed =>
      (_baseSpeed + _elapsedSeconds * _speedRampPerSecond)
          .clamp(_baseSpeed, _maxSpeed);

  int _score = 0;
  int get score => _score;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  late Player player;
  late ScrollingBackground background;
  late ObstacleSpawner spawner;

  @override
  Color backgroundColor() => const Color(0xFF0B0E1A);

  @override
  Future<void> onLoad() async {
    await AudioManager.instance.preload();

    background = ScrollingBackground();
    await add(background);

    player = Player(
      onCrash: _handleCrash,
    );
    await add(player);

    spawner = ObstacleSpawner(
      onObstaclePassed: _addScore,
    );
    await add(spawner);

    pauseEngine(); // Oyun, kullanıcı "Başlat" demeden akmasın.
  }

  /// Menüden "Oyna" ile çağrılır: sayaçları sıfırlar ve döngüyü başlatır.
  void startRun() {
    _elapsedSeconds = 0;
    _score = 0;
    _isRunning = true;
    player.reset();
    spawner.reset();
    onScoreChanged(_score);
    resumeEngine();
  }

  void _addScore(int amount) {
    if (!_isRunning) return;
    _score += amount;
    onScoreChanged(_score);
  }

  Future<void> _handleCrash() async {
    if (!_isRunning) return;
    _isRunning = false;
    AudioManager.instance.playHit();
    await AudioManager.instance.vibrateShort();
    await StorageManager.instance.submitScore(_score);
    pauseEngine();
    onGameOver(_score);
  }

  /// Duraklatma menüsü için dışarıdan çağrılır.
  void pauseRun() {
    if (!_isRunning) return;
    pauseEngine();
  }

  void resumeRun() {
    if (!_isRunning) return;
    resumeEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isRunning) {
      _elapsedSeconds += dt;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (_isRunning) {
      player.jump();
    }
  }
}
