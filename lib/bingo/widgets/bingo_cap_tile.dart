import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:penalty_game/asset_paths.dart';
import 'package:penalty_game/bingo/bingo_layout.dart';
import 'package:penalty_game/bingo/bingo_prize.dart';

class BingoCapTile extends StatefulWidget {
  const BingoCapTile({
    super.key,
    required this.prize,
    required this.revealed,
    required this.onTap,
  });

  final BingoPrize? prize;
  final bool revealed;
  final VoidCallback? onTap;

  @override
  State<BingoCapTile> createState() => _BingoCapTileState();
}

class _BingoCapTileState extends State<BingoCapTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _showPrize = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: BingoLayout.flipDuration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addListener(_onFlipTick);
    _showPrize = widget.revealed;
    if (widget.revealed) {
      _controller.value = 1;
    }
  }

  void _onFlipTick() {
    final showPrize = _animation.value >= 0.5;
    if (showPrize != _showPrize) {
      setState(() => _showPrize = showPrize);
    }
  }

  @override
  void didUpdateWidget(covariant BingoCapTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealed && !oldWidget.revealed) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onFlipTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.revealed ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          // Keep front face readable after the midpoint swap.
          final displayAngle = _animation.value >= 0.5 ? angle - math.pi : angle;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(displayAngle),
            child: child,
          );
        },
        child: Image.asset(
          _showPrize && widget.prize != null
              ? widget.prize!.assetPath
              : '${AssetPaths.bingoImages}closed.png',
          width: BingoLayout.capWidth,
          height: BingoLayout.capHeight,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
