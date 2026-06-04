import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'package:penalty_game/kiosk_screen_size.dart';
import 'package:penalty_game/wheel/models/wheel_prize.dart';
import 'package:penalty_game/wheel/wheel_layout.dart';
import 'package:penalty_game/wheel/widgets/prize_card.dart';

class WheelCarousel3D extends StatefulWidget {
  const WheelCarousel3D({
    super.key,
    required this.prizes,
    required this.minRotations,
    required this.spinDurationMs,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  final List<WheelPrize> prizes;
  final int minRotations;
  final int spinDurationMs;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  @override
  State<WheelCarousel3D> createState() => WheelCarousel3DState();
}

class WheelCarousel3DState extends State<WheelCarousel3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _scrollAnimation;

  double _scrollOffset = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      if (_scrollAnimation != null) {
        setState(() => _scrollOffset = _scrollAnimation!.value);
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
        widget.onAnimationEnd?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get isAnimating => _isAnimating;

  int _mod(int value, int n) => ((value % n) + n) % n;

  /// Spins left at least [minRotations] full loops, then lands on [winnerIndex].
  void spinToIndex(int winnerIndex) {
    if (_isAnimating || widget.prizes.isEmpty) return;

    final n = widget.prizes.length;
    final currentSlot = _scrollOffset.round();
    final delta = _mod(winnerIndex - _mod(currentSlot, n), n);
    final target =
        _scrollOffset + widget.minRotations * n + delta;

    _scrollAnimation = Tween<double>(begin: _scrollOffset, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _isAnimating = true;
    widget.onAnimationStart?.call();
    _controller
      ..duration = Duration(milliseconds: widget.spinDurationMs)
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WheelLayout.barHeight,
      width: KioskScreenSize.width,
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Soft depth vignette behind the cylinder
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.1,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
            ..._buildCards(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    final baseIndex = _scrollOffset.floor();
    final frac = _scrollOffset - baseIndex;
    final centerX = KioskScreenSize.width / 2;

    final layers = <_CardLayer>[];
    for (var rel = -6; rel <= 6; rel++) {
      final slotOffset = rel - frac;
      if (slotOffset.abs() > 5.5) continue;

      final slotIndex = baseIndex + rel;
      final prizeIndex = _mod(slotIndex, widget.prizes.length);
      layers.add(
        _CardLayer(
          slotOffset: slotOffset,
          prize: widget.prizes[prizeIndex],
        ),
      );
    }

    layers.sort((a, b) => b.slotOffset.abs().compareTo(a.slotOffset.abs()));

    return layers.map((layer) {
      final slotOffset = layer.slotOffset;
      final abs = slotOffset.abs();

      final rotateY = slotOffset * WheelLayout.carouselRotateY;
      final scale = (1 - abs * WheelLayout.carouselScaleFalloff)
          .clamp(WheelLayout.carouselMinScale, 1.0);
      final opacity = (1 - abs * WheelLayout.carouselOpacityFalloff)
          .clamp(WheelLayout.carouselMinOpacity, 1.0);
      final depthZ = -abs * WheelLayout.carouselDepthZ;
      final dropY = abs * WheelLayout.carouselVerticalDrop;

      final x = centerX + slotOffset * WheelLayout.slotWidth - WheelLayout.cardWidth / 2;

      return Positioned(
        left: x,
        top: (WheelLayout.barHeight - WheelLayout.cardHeight * scale) / 2 + dropY,
        child: Opacity(
          opacity: opacity,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, WheelLayout.carouselPerspective)
              ..translateByVector3(Vector3(0, 0, depthZ))
              ..rotateY(rotateY),
            child: Transform.scale(
              scale: scale,
              child: SizedBox(
                width: WheelLayout.cardWidth,
                height: WheelLayout.cardHeight,
                child: PrizeCard(prize: layer.prize),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _CardLayer {
  const _CardLayer({required this.slotOffset, required this.prize});

  final double slotOffset;
  final WheelPrize prize;
}
