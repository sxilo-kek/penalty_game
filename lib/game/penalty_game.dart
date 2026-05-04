import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'dart:math';

import 'package:penalty_game/game/aim_indicator.dart';
import 'package:penalty_game/game/goalkeeper.dart';
import 'package:penalty_game/game/goal_area.dart';
import 'package:penalty_game/game/secure_score.dart';
import 'package:penalty_game/game/flash.dart';
import 'package:penalty_game/game/blocker.dart';
import 'package:penalty_game/game/ball.dart';

class PenaltyGame extends FlameGame with HasCollisionDetection, PanDetector {
  Ball? ball;
  late Goalkeeper keeper;
  late GoalArea goal;
  late AimIndicator aimIndicator;
  late Flash _flash;

  final SecureScore _score = SecureScore();
  int get score => _score.value;

  int saves = 0;
  bool isGameOver = false;

  VoidCallback? onScoreChanged;

  static const int maxSaves = 1;
  int get difficultyLevel => (score ~/ 3).clamp(0, 5);

  final List<Blocker> _blockers = [];
  final _rng = Random();
  Vector2? _dragStart, _dragCurrent;

  void addScore(int points) => _score.add(points);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _drawPitch();
    goal = GoalArea(Vector2(size.x / 2, 380));
    add(goal);
    keeper = Goalkeeper(Vector2(size.x / 2, 520));
    add(keeper);
    aimIndicator = AimIndicator();
    add(aimIndicator);
    _flash = Flash();
    add(_flash);
    resetBall();
  }

  void triggerGameOver() {
    if (isGameOver) return;
    isGameOver = true;
    overlays.add('gameOver');
    notifyHud();
  }

  Future<void> _drawPitch() async {
    final fieldSprite = await Sprite.load('field.png');
    add(SpriteComponent(sprite: fieldSprite, size: size, position: Vector2.zero()));
  }

  void _updateBlockers() {
    for (final b in _blockers) b.removeFromParent();
    _blockers.clear();
    final level = difficultyLevel;
    int count = 0;
    if (level >= 2) count = 1;
    if (level >= 3) count = 2;
    if (level >= 5) count = 3;
    for (int i = 0; i < count; i++) {
      final yPos = 800.0 + i * 350 + _rng.nextDouble() * 120;
      final spd = 400.0 + level * 100 + _rng.nextDouble() * 100;
      _blockers.add(Blocker(
        position: Vector2(size.x / 2 + (i.isEven ? -250 : 250), yPos),
        speed: spd,
      )..addToParent(this));
    }
  }

  void resetBall() {
    if (ball != null && ball!.isMounted) ball!.removeFromParent();
    ball = Ball(Vector2(size.x / 2, size.y - 600));
    add(ball!);
    _updateBlockers();
    keeper.updateDifficulty(difficultyLevel);
    Future.microtask(() => aimIndicator.hide());
  }

  void flashGoal() => _flash.trigger(const Color(0xFF00E676));
  void flashSave() => _flash.trigger(const Color(0xFFFF1744).withValues(alpha: 0.55));

  @override
  void onPanStart(DragStartInfo info) {
    if (ball!.isShot || isGameOver) return;
    _dragStart = info.eventPosition.global.clone();
    _dragCurrent = _dragStart!.clone();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (ball!.isShot || isGameOver || _dragStart == null) return;
    _dragCurrent = info.eventPosition.global.clone();
    final drag = _dragStart! - _dragCurrent!;
    final power = (drag.length / 500.0).clamp(0.0, 1.0);
    aimIndicator.update2(ballPos: ball!.position, direction: drag, power: power);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (ball!.isShot || _dragStart == null || _dragCurrent == null || isGameOver) return;
    final drag = _dragStart! - _dragCurrent!;
    final power = (drag.length / 500.0).clamp(0.0, 1.0);
    if (power > 0.05) {
      ball?.velocity = drag.normalized() * power * 2200;
      ball?.isShot = true;
      aimIndicator.hide();
    }
    _dragStart = null;
    _dragCurrent = null;
  }

  void restartGame() {
    isGameOver = false;
    saves = 0;
    _score.reset();
    for (final b in _blockers) {
      b.removeFromParent();
    }
    _blockers.clear();
    if (ball != null && ball!.isMounted) ball!.removeFromParent();
    ball = null;
    resetBall();
    notifyHud();
  }

  void notifyHud() => onScoreChanged?.call();
}
