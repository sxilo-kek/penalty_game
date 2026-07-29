import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:penalty_game/bingo/bingo_layout.dart';

class BingoConfetti extends StatefulWidget {
  const BingoConfetti({
    super.key,
    required this.origin,
  });

  final Offset origin;

  @override
  State<BingoConfetti> createState() => _BingoConfettiState();
}

class _BingoConfettiState extends State<BingoConfetti> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  static const _colors = [Color(0xFFE41E2B), Color(0xFFFFFFFF), Color(0xFFFFD54F), Color(0xFFFF8A80), Color(0xFFFCE4EC)];

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particles = List.generate(72, (i) {
      final angle = -math.pi / 2 + (random.nextDouble() - 0.5) * math.pi;
      final speed = 900 + random.nextDouble() * 1400;
      return _Particle(
        color: _colors[i % _colors.length],
        vx: math.cos(angle) * speed,
        vy: math.sin(angle) * speed - 400,
        size: 14 + random.nextDouble() * 22,
        rotationSpeed: (random.nextDouble() - 0.5) * 10,
        wobble: random.nextDouble() * math.pi * 2,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: BingoLayout.confettiDuration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size(BingoLayout.canvasWidth, BingoLayout.canvasHeight),
            painter: _ConfettiPainter(progress: _controller.value, origin: widget.origin, particles: _particles),
          );
        },
      ),
    );
  }
}

class _Particle {
  const _Particle({required this.color, required this.vx, required this.vy, required this.size, required this.rotationSpeed, required this.wobble});

  final Color color;
  final double vx;
  final double vy;
  final double size;
  final double rotationSpeed;
  final double wobble;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({
    required this.progress,
    required this.origin,
    required this.particles,
  });

  final double progress;
  final Offset origin;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final time = progress * BingoLayout.confettiDuration.inMilliseconds / 1000;
    final gravity = 2200.0;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final x = origin.dx + p.vx * time + math.sin(time * 8 + p.wobble) * 30;
      final y = origin.dy + p.vy * time + 0.5 * gravity * time * time;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      paint.color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotationSpeed * time);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.45),
          const Radius.circular(3),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
