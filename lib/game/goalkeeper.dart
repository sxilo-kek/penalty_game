import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:penalty_game/game/penalty_game.dart';

class Goalkeeper extends SpriteComponent with HasGameReference<PenaltyGame>, CollisionCallbacks {
  double speed = 340;
  int direction = 1;

  final _rng = Random();
  double _jiggleCooldown = 1.5;
  double _jiggleTimeLeft = 0;
  double _jiggleBaseX = 0;
  double _jigglePhase = 0;

  static const _jiggleDuration = 0.55;
  static const _jiggleAmplitude = 18.0;
  static const _jiggleFrequency = 38.0;

  Goalkeeper(Vector2 position) : super(size: Vector2(320, 250), position: position, anchor: Anchor.center);

  bool get _isJiggling => _jiggleTimeLeft > 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('goalkeeper.png', images: game.images);
    add(RectangleHitbox(size: Vector2(310, 180), position: Vector2(5, 70)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isJiggling) {
      _updateJiggle(dt);
      return;
    }

    _jiggleCooldown -= dt;
    if (_jiggleCooldown <= 0 && _rng.nextDouble() < 0.012) {
      _startJiggle();
      return;
    }

    final halfW = size.x / 2;
    position.x += direction * speed * dt;

    if (position.x <= halfW + 10) {
      position.x = halfW + 10;
      direction = 1;
    } else if (position.x >= game.size.x - halfW - 10) {
      position.x = game.size.x - halfW - 10;
      direction = -1;
    }

    _syncFacing();
  }

  void _startJiggle() {
    _jiggleBaseX = position.x;
    _jiggleTimeLeft = _jiggleDuration;
    _jigglePhase = 0;
    _jiggleCooldown = 2.5 + _rng.nextDouble() * 4.0;
  }

  void _updateJiggle(double dt) {
    _jiggleTimeLeft -= dt;
    _jigglePhase += dt * _jiggleFrequency;

    final t = 1 - (_jiggleTimeLeft / _jiggleDuration).clamp(0.0, 1.0);
    final fade = sin(t * pi);
    position.x = _jiggleBaseX + sin(_jigglePhase) * _jiggleAmplitude * fade;

    angle = sin(_jigglePhase * 1.4) * 0.06 * fade;

    if (_jiggleTimeLeft <= 0) {
      position.x = _jiggleBaseX;
      angle = 0;
      _syncFacing();
    }
  }

  void _syncFacing() {
    if (direction < 0 && !isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    } else if (direction > 0 && isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    }
  }

  void updateDifficulty(int level) {
    speed = 340 + level * 55.0 + (level >= 5 ? 90 : 0);
  }
}
