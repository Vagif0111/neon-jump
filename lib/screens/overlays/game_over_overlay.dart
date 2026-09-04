import 'package:flutter/material.dart';

import '../../game/managers/storage_manager.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({
    super.key,
    required this.finalScore,
    required this.onRestart,
    required this.onHome,
  });

  final int finalScore;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final highScore = StorageManager.instance.highScore;
    final isNewRecord = finalScore > 0 && finalScore == highScore;

    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNewRecord) ...[
              const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 42),
              const SizedBox(height: 6),
              const Text(
                'YENİ REKOR!',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
            ],
            const Text(
              'OYUN BİTTİ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              '$finalScore',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 52,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'En Yüksek Skor: $highScore',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundButton(
                  icon: Icons.home_rounded,
                  onTap: onHome,
                  background: const Color(0xFF1B1F35),
                ),
                const SizedBox(width: 20),
                _RoundButton(
                  icon: Icons.refresh_rounded,
                  onTap: onRestart,
                  background: const Color(0xFF00F5FF),
                  large: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    required this.background,
    this.large = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 64.0 : 52.0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: large ? 30 : 24),
      ),
    );
  }
}
