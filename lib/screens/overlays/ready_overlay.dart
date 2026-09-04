import 'package:flutter/material.dart';

class ReadyOverlay extends StatelessWidget {
  const ReadyOverlay({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.55),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'HAZIR MISIN?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ekrana dokunarak zıpla,\nengellerden kaç!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onStart,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00F5FF), Color(0xFF7B2FFF)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'BAŞLA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
