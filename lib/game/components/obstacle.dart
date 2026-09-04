import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../neon_jump_game.dart';

/// Sağdan sola doğru hareket eden diken/engel.
///
/// PLACEHOLDER GÖRSEL: Üçgen "diken" şekli kod ile çiziliyor.
/// Gerçek asset için bkz. ASSETS_TODO.md -> "obstacle.png"
/// (Kenney Pixel Platformer paketindeki "spike" veya "saw" sprite'ı).
class Obstacle extends PositionComponent
    with CollisionCallbacks, HasGameReference<NeonJumpGame> {
  Obstacle({
    required double groundY,
    required Vector2 obstacleSize,
  }) : super(
          size: obstacleSize,
          anchor: Anchor.bottomLeft,
          position: Vector2(400, groundY),
        );

  bool _scored = false;
  bool get scored => _scored;
  void markScored() => _scored = true;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(size.x * 0.7, size.y * 0.8),
      position: Vector2(size.x * 0.15, size.y * 0.2),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= game.worldSpeed * dt;

    // Ekranın solundan çıkınca kendini temizle (spawner sayaç tutar).
    if (position.x < -size.x - 20) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y)
      ..lineTo(0, size.y)
      ..close();

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF2D95), Color(0xFFFF5C00)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(size.toRect());

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = const Color(0xFFFF2D95).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, borderPaint);
  }
}
