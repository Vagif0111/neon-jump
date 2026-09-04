import 'package:flutter/material.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({
    super.key,
    required this.score,
    required this.onPausePressed,
  });

  final int score;
  final VoidCallback onPausePressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _CircleIconButton(
              icon: Icons.pause_rounded,
              onTap: onPausePressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
