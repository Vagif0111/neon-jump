import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../neon_jump_game.dart';
import 'player.dart';

/// Basit paralaks arka plan: uzak yıldızlar (yavaş) + zemin çizgisi (hızlı).
///
/// PLACEHOLDER GÖRSEL: Şu an düz renk + kod ile çizilmiş noktalardan oluşan
/// bir gökyüzü kullanılıyor. Gerçek asset için bkz. ASSETS_TODO.md ->
/// "background.png" (Kenney "Background Elements" / "Space Shooter Redux"
/// paketinden tekrarlanabilir (tileable) bir gökyüzü/şehir silüeti).
class ScrollingBackground extends Component
    with HasGameReference<NeonJumpGame> {
  final List<Offset> _stars = [];
  double _groundScrollX = 0;

  @override
  Future<void> onLoad() async {
    // Sabit bir yıldız deseni üret (performans için her frame yeniden
    // hesaplanmaz).
    final rnd = List.generate(60, (i) => i);
    for (final i in rnd) {
      _stars.add(Offset(
        (i * 37) % 400.0,
        (i * 53) % 700.0,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isRunning) return;
    // Zemin çizgisi, dünya hızının 1x'i ile kayar (paralaks derinlik).
    _groundScrollX -= game.worldSpeed * dt;
    if (_groundScrollX <= -40) {
      _groundScrollX += 40;
    }
  }

  @override
  void render(Canvas canvas) {
    final size = game.size;

    // Arka plan degrade gökyüzü.
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B0E1A), Color(0xFF161A33)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), skyPaint);

    // Sabit yıldızlar.
    final starPaint = Paint()..color = Colors.white.withOpacity(0.5);
    for (final star in _stars) {
      final x = star.dx % size.x;
      final y = star.dy % (size.y - Player.groundYFromBottom);
      canvas.drawCircle(Offset(x, y), 1.4, starPaint);
    }

    // Zemin çizgisi (hareketli, kesikli çizgi hissi).
    final groundY = size.y - Player.groundYFromBottom;
    final groundLinePaint = Paint()
      ..color = const Color(0xFF00F5FF)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, groundY),
      Offset(size.x, groundY),
      groundLinePaint,
    );

    final dashPaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.35)
      ..strokeWidth = 2;
    var dashX = _groundScrollX;
    while (dashX < size.x) {
      canvas.drawLine(
        Offset(dashX, groundY + 10),
        Offset(dashX + 16, groundY + 10),
        dashPaint,
      );
      dashX += 40;
    }

    // Zeminin altını dolu koyu renkle kapat.
    final groundFillPaint = Paint()..color = const Color(0xFF05060C);
    canvas.drawRect(
      Rect.fromLTWH(0, groundY + 1, size.x, size.y - groundY),
      groundFillPaint,
    );
  }
}
