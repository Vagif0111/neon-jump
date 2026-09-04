import 'dart:math';

import 'package:flame/components.dart';

import '../neon_jump_game.dart';
import 'obstacle.dart';
import 'player.dart';

/// Belirli aralıklarla engel üreten ve skor bonusu tetikleyen component.
///
/// Zorluk artışı: spawn aralığı, oyun hızlandıkça kademeli olarak kısalır
/// (ama oynanabilirliği korumak için bir alt sınırla sınırlanır).
class ObstacleSpawner extends Component with HasGameReference<NeonJumpGame> {
  ObstacleSpawner({required this.onObstaclePassed});

  final void Function(int amount) onObstaclePassed;

  final Random _random = Random();
  double _timeSinceLastSpawn = 0;
  double _nextSpawnInterval = 1.6;

  static const double _minSpawnInterval = 0.75;
  static const double _maxSpawnInterval = 1.7;

  void reset() {
    _timeSinceLastSpawn = 0;
    _nextSpawnInterval = _maxSpawnInterval;
    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isRunning) return;

    _timeSinceLastSpawn += dt;
    if (_timeSinceLastSpawn >= _nextSpawnInterval) {
      _timeSinceLastSpawn = 0;
      _spawnObstacle();
      _rollNextInterval();
    }

    _checkPassedObstacles();
  }

  void _rollNextInterval() {
    // Hız arttıkça (worldSpeed yükseldikçe) aralık daralır.
    final speedRatio =
        (game.worldSpeed - 260) / (620 - 260); // 0.0 -> 1.0 arası
    final base = _maxSpawnInterval -
        (speedRatio.clamp(0, 1) * (_maxSpawnInterval - _minSpawnInterval));
    final jitter = _random.nextDouble() * 0.4 - 0.2; // +/-0.2 sn rastgelelik
    _nextSpawnInterval = (base + jitter).clamp(_minSpawnInterval, _maxSpawnInterval);
  }

  void _spawnObstacle() {
    final groundY = game.player.groundY;
    // Rastgele engel boyutu (biraz varyasyon = görsel çeşitlilik).
    final height = 40.0 + _random.nextDouble() * 26;
    final width = 34.0 + _random.nextDouble() * 14;

    final obstacle = Obstacle(
      groundY: groundY,
      obstacleSize: Vector2(width, height),
    );
    parent?.add(obstacle);
  }

  void _checkPassedObstacles() {
    for (final obstacle in children.whereType<Obstacle>()) {
      if (!obstacle.scored && obstacle.position.x + obstacle.size.x < Player.fixedX) {
        obstacle.markScored();
        onObstaclePassed(1);
      }
    }
  }
}
