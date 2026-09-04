import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../managers/audio_manager.dart';
import '../neon_jump_game.dart';
import 'obstacle.dart';

/// Oyuncu karakteri.
///
/// PLACEHOLDER GÖRSEL: Şu an neon renkli yuvarlak köşeli bir dikdörtgen
/// çiziliyor. Gerçek asset için bkz. ASSETS_TODO.md ->
/// "player.png" (Kenney Pixel Platformer / Abstract Platformer paketinden
/// tek bir karakter kare sprite'ı, 32x32 veya 48x48 px, şeffaf arka plan).
class Player extends PositionComponent
    with CollisionCallbacks, HasGameReference<NeonJumpGame> {
  Player({required this.onCrash})
      : super(size: Vector2(46, 46), anchor: Anchor.bottomLeft);

  final Future<void> Function() onCrash;

  // --- Zıplama fiziği ---
  static const double groundYFromBottom = 90; // zeminin ekran altından yüksekliği
  static const double gravity = 1900; // px/sn^2
  static const double jumpVelocity = -760; // px/sn (negatif = yukarı)

  double _velocityY = 0;
  bool _isOnGround = true;
  bool _isCrashed = false;

  double get groundY => game.size.y - groundYFromBottom;

  static const double fixedX = 70;

  @override
  Future<void> onLoad() async {
    position = Vector2(fixedX, groundY);
    add(RectangleHitbox(
      size: Vector2(size.x * 0.8, size.y * 0.9),
      position: Vector2(size.x * 0.1, size.y * 0.05),
    ));
  }

  void reset() {
    _velocityY = 0;
    _isOnGround = true;
    _isCrashed = false;
    position = Vector2(fixedX, groundY);
    angle = 0;
  }

  void jump() {
    if (_isCrashed) return;
    if (_isOnGround) {
      _velocityY = jumpVelocity;
      _isOnGround = false;
      AudioManager.instance.playJump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isCrashed) return;

    // Basit yerçekimi simülasyonu.
    _velocityY += gravity * dt;
    position.y += _velocityY * dt;

    final currentGroundY = groundY;
    if (position.y >= currentGroundY) {
      position.y = currentGroundY;
      _velocityY = 0;
      _isOnGround = true;
    }

    // Havadayken hafif dönüş efekti (görsel canlılık için).
    if (!_isOnGround) {
      angle = (_velocityY / 2200).clamp(-0.5, 0.5);
    } else {
      angle = 0;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle && !_isCrashed) {
      _isCrashed = true;
      onCrash();
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00F5FF), Color(0xFF7B2FFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);

    // Hafif dış çizgi (neon glow hissi).
    final borderPaint = Paint()
      ..color = const Color(0xFF00F5FF).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);
  }
}
