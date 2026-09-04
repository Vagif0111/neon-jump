import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/neon_jump_game.dart';
import 'overlays/game_over_overlay.dart';
import 'overlays/hud_overlay.dart';
import 'overlays/pause_overlay.dart';
import 'overlays/ready_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final NeonJumpGame _game;
  int _score = 0;
  int _finalScore = 0;

  static const overlayReady = 'ready';
  static const overlayHud = 'hud';
  static const overlayPause = 'pause';
  static const overlayGameOver = 'gameOver';

  @override
  void initState() {
    super.initState();
    _game = NeonJumpGame(
      onScoreChanged: (score) => setState(() => _score = score),
      onGameOver: (finalScore) {
        setState(() => _finalScore = finalScore);
        _game.overlays.remove(overlayHud);
        _game.overlays.add(overlayGameOver);
      },
    );
  }

  void _startGame() {
    _game.overlays.remove(overlayReady);
    _game.overlays.remove(overlayGameOver);
    _game.overlays.add(overlayHud);
    _game.startRun();
  }

  void _pauseGame() {
    _game.pauseRun();
    _game.overlays.add(overlayPause);
  }

  void _resumeGame() {
    _game.overlays.remove(overlayPause);
    _game.resumeRun();
  }

  void _restartGame() {
    _game.overlays.remove(overlayPause);
    _game.overlays.remove(overlayGameOver);
    _game.overlays.add(overlayHud);
    _game.startRun();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget<NeonJumpGame>(
              game: _game,
              initialActiveOverlays: const [overlayReady],
              overlayBuilderMap: {
                overlayReady: (context, game) => ReadyOverlay(
                      onStart: _startGame,
                    ),
                overlayHud: (context, game) => HudOverlay(
                      score: _score,
                      onPausePressed: _pauseGame,
                    ),
                overlayPause: (context, game) => PauseOverlay(
                      onResume: _resumeGame,
                      onRestart: _restartGame,
                      onHome: () => Navigator.of(context).pop(),
                    ),
                overlayGameOver: (context, game) => GameOverOverlay(
                      finalScore: _finalScore,
                      onRestart: _restartGame,
                      onHome: () => Navigator.of(context).pop(),
                    ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
