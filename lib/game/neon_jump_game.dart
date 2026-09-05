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

class NeonJumpGame extends FlameGame
    with HasCollisionDetection, TapCallbacks {
  NeonJumpGame({
    required this.onScoreChanged,
    required this.onGameOver,
  });

  final void Function(int score) onScoreChanged;
  final void Function(int finalScore) onGameOver;

  static const double _baseSpeed = 260.0;
  static const double _maxSpeed = 620.0;
  static const double _speedRampPerSecond = 6.0;

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

    pauseEngine();
  }

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
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (_isRunning) {
      player.jump();
    }
  }
}
