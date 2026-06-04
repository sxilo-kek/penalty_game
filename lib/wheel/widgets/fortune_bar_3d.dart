import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:penalty_game/kiosk_screen_size.dart';
import 'package:penalty_game/wheel/wheel_layout.dart';

/// [FortuneBar] with 3D perspective — side items slope away left/right.
class FortuneBar3D extends StatefulWidget {
  const FortuneBar3D({
    super.key,
    required this.selected,
    required this.items,
    required this.height,
    this.rotationCount = FortuneWidget.kDefaultRotationCount,
    this.duration = FortuneWidget.kDefaultDuration,
    this.visibleItemCount = FortuneBar.kDefaultVisibleItemCount,
    this.fullWidth = false,
    this.animateFirst = false,
    this.curve = FortuneCurve.spin,
    this.onAnimationStart,
    this.onAnimationEnd,
  });

  final Stream<int> selected;
  final List<FortuneItem> items;
  final double height;
  final int rotationCount;
  final Duration duration;
  final int visibleItemCount;
  final bool fullWidth;
  final bool animateFirst;
  final Curve curve;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  @override
  State<FortuneBar3D> createState() => _FortuneBar3DState();
}

class _FortuneBar3DState extends State<FortuneBar3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationCtrl;
  late Animation<double> _animation;
  late StreamSubscription<int> _subscription;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationCtrl = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _animationCtrl, curve: widget.curve);

    _subscription = widget.selected.listen((index) {
      setState(() => _selectedIndex = index);
      _animate();
    });

    if (widget.animateFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _animate());
    }
  }

  @override
  void didUpdateWidget(FortuneBar3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _animationCtrl.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _animationCtrl.dispose();
    super.dispose();
  }

  Future<void> _animate() async {
    if (_animationCtrl.isAnimating) return;
    widget.onAnimationStart?.call();
    await _animationCtrl.forward(from: 0);
    widget.onAnimationEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final visibleCount =
        widget.visibleItemCount.clamp(1, widget.items.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.fullWidth
            ? KioskScreenSize.width
            : constraints.maxWidth;
        final size = Size(width, widget.height);

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final itemPosition =
                widget.items.length * widget.rotationCount + _selectedIndex;
            final position = _animation.value * itemPosition;

            return _InfiniteBar3D(
              size: size,
              visibleItemCount: visibleCount,
              position: position,
              centerPosition: 1,
              children: [
                for (final item in widget.items) item.child,
              ],
            );
          },
        );
      },
    );
  }
}

class _InfiniteBar3D extends StatelessWidget {
  const _InfiniteBar3D({
    required this.children,
    required this.size,
    required this.visibleItemCount,
    required this.position,
    required this.centerPosition,
  });

  final List<Widget> children;
  final Size size;
  final int visibleItemCount;
  final double position;
  final int centerPosition;

  double _centerSlot() => visibleItemCount / 2 - 0.5;

  Widget _wrap3D({required Widget child, required double slotOffset}) {
    if (slotOffset.abs() < 0.01) {
      return child;
    }

    final abs = slotOffset.abs();
    // Left items (negative offset) turn toward the left; right toward the right.
    final rotateY = -slotOffset * WheelLayout.carouselRotateY;
    final scale = (1 - abs * WheelLayout.carouselScaleFalloff)
        .clamp(WheelLayout.carouselMinScale, 1.0);
    final opacity = (1 - abs * WheelLayout.carouselOpacityFalloff)
        .clamp(WheelLayout.carouselMinOpacity, 1.0);
    final depthZ = -abs * WheelLayout.carouselDepthZ;
    final dropY = abs * WheelLayout.carouselVerticalDrop;
    // Side slopes lean outward with their facing direction.
    final rotateX = -slotOffset * WheelLayout.carouselSlopeTilt;

    return Padding(
      padding: EdgeInsets.only(top: dropY),
      child: Opacity(
        opacity: opacity,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, WheelLayout.carouselPerspective)
            ..setTranslationRaw(0, 0, depthZ)
            ..rotateY(rotateY)
            ..rotateX(rotateX),
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLengthTwo = children.length == 2;
    final normalizedPosition = (-position + centerPosition) % children.length -
        (isLengthTwo ? 0.5 : 0.0);
    final isLockedIn = position % 1 == 0;
    final overflowItemCount = normalizedPosition.ceil() + (isLockedIn ? 1 : 0);
    final nonIntOffset = normalizedPosition - normalizedPosition.floor();
    final itemWidth = size.width / visibleItemCount;
    final center = _centerSlot();

    final layers = <_BarLayer>[];

    void addLayer(int childIndex, double pos) {
      final slotOffset = pos - center;
      if (slotOffset.abs() > visibleItemCount + 1) return;
      layers.add(
        _BarLayer(
          x: pos * itemWidth,
          slotOffset: slotOffset,
          child: children[childIndex % children.length],
        ),
      );
    }

    if (isLengthTwo) {
      addLayer(0, normalizedPosition + children.length);
    }

    for (var i = 0; i < overflowItemCount; i++) {
      final childIndex = (i -
              overflowItemCount -
              (isLengthTwo && isLockedIn ? 1 : 0)) %
          children.length;
      addLayer(childIndex, i + nonIntOffset - 1);
    }

    for (var i = 0; i < children.length; i++) {
      addLayer(i, normalizedPosition + i);
    }

    layers.sort((a, b) => b.slotOffset.abs().compareTo(a.slotOffset.abs()));

    return ClipRect(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.05,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            for (final layer in layers)
              Positioned(
                left: layer.x,
                top: 0,
                width: itemWidth,
                height: size.height,
                child: _wrap3D(
                  slotOffset: layer.slotOffset,
                  child: layer.child,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BarLayer {
  const _BarLayer({
    required this.x,
    required this.slotOffset,
    required this.child,
  });

  final double x;
  final double slotOffset;
  final Widget child;
}
