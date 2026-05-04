import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:penalty_game/game/penalty_game.dart';

class AimIndicator extends Component with HasGameReference<PenaltyGame> {
  Vector2 ballPos = Vector2.zero();
  Vector2 direction = Vector2.zero();
  double power = 0;
  bool visible = false;
  double time = 0;

  void update2({
    required Vector2 ballPos,
    required Vector2 direction,
    required double power,
  }) {
    this.ballPos = ballPos.clone();
    this.direction = direction.clone();
    this.power = power;
    visible = power > 0.02;
  }

  void hide() => visible = false;

  @override
  void update(double dt) => time += dt;

  @override
  void render(Canvas canvas) {
    if (!visible || direction.length < 1) return;

    final dir = direction.normalized();
    final start = Offset(ballPos.x, ballPos.y);
    final totalLen = 150.0 + power * 600.0; // was 50 + 200
    const spacing = 40.0; // was 13
    final dotCount = (totalLen / spacing).floor();
    final aimColor = Color.lerp(Colors.green, Colors.red, power)!;

    // Dots
    for (int i = 1; i <= dotCount; i++) {
      final t = i / dotCount;
      final anim = ((t - time * 1.5) % 1.0 + 1.0) % 1.0;
      final sz = (12.0 * (1 - t * 0.45)).clamp(3.0, 14.0); // was 3.5/4.0
      final alpha = ((1 - t * 0.75) * (0.5 + anim * 0.5)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(start.dx + dir.x * i * spacing, start.dy + dir.y * i * spacing),
        sz,
        Paint()..color = aimColor.withValues(alpha: alpha),
      );
    }

    // Arrowhead glow
    final tipX = start.dx + dir.x * (totalLen + 40);
    final tipY = start.dy + dir.y * (totalLen + 40);
    canvas.drawCircle(
      Offset(tipX, tipY),
      50, // was 14
      Paint()
        ..color = aimColor.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30), // was 10
    );

    // Arrowhead triangle
    final px = -dir.y, py = dir.x;
    final bx = tipX - dir.x * 60, by = tipY - dir.y * 60; // was 20
    final path = Path()
      ..moveTo(tipX, tipY)
      ..lineTo(bx + px * 35, by + py * 35) // was 10
      ..lineTo(bx - px * 35, by - py * 35) // was 10
      ..close();
    canvas.drawPath(path, Paint()..color = aimColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0, // was 1.5
    );

    // Power bar
    const bW = 420.0, bH = 50.0; // was 130/15
    final bX = ballPos.x - bW / 2;
    final bY = ballPos.y + 90.0; // was 30

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bX, bY, bW, bH), const Radius.circular(25)),
      Paint()..color = Colors.black.withValues(alpha: 0.65),
    );
    if (power > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(bX, bY, bW * power, bH), const Radius.circular(25)),
        Paint()
          ..shader = LinearGradient(
            colors: [Colors.green.withValues(alpha: 0.9), aimColor],
          ).createShader(Rect.fromLTWH(bX, bY, bW, bH)),
      );
      if (power > 0.15) {
        canvas.drawRect(
          Rect.fromLTWH(bX + bW * power - 8, bY + 6, 8, bH - 12),
          Paint()..color = Colors.white.withValues(alpha: 0.4),
        );
      }
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bX, bY, bW, bH), const Radius.circular(25)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0, // was 1.5
    );

    // Percentage text
    final tp = TextPainter(
      text: TextSpan(
        text: '${(power * 100).round()}%',
        style: TextStyle(
          color: power > 0.5 ? Colors.white : Colors.white70,
          fontSize: 32, // was 10
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(bX + bW / 2 - tp.width / 2, bY + 9));

    // SHOOT! text
    if (power > 0.82) {
      final pulse = sin(time * 8) * 0.3 + 0.7;
      final stp = TextPainter(
        text: TextSpan(
          text: '⚡ SHOOT! ⚡',
          style: TextStyle(
            color: Colors.red.withValues(alpha: pulse),
            fontSize: 72, // was 13
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      stp.paint(canvas, Offset(bX + bW / 2 - stp.width / 2, bY - 90)); // was -22
    }
  }
}
