import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:penalty_game/asset_paths.dart';
import 'package:penalty_game/bingo/bingo_layout.dart';
import 'package:penalty_game/bingo/bingo_prize.dart';

class BingoCapTile extends StatefulWidget {
  const BingoCapTile({super.key, required this.prize, required this.revealed, required this.jiggling, required this.jigglePhase, required this.onTap});

  final BingoPrize prize;
  final bool revealed;
  final bool jiggling;
  final double jigglePhase;
  final VoidCallback onTap;

  @override
  State<BingoCapTile> createState() => _BingoCapTileState();
}

class _BingoCapTileState extends State<BingoCapTile> with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  bool _showPrize = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(vsync: this, duration: BingoLayout.flipDuration);
    _flipAnimation = CurvedAnimation(parent: _flipController, curve: Curves.easeInOut);
    _flipController.addListener(_onFlipTick);
    _showPrize = widget.revealed;
    if (widget.revealed) {
      _flipController.value = 1;
    }
  }

  void _onFlipTick() {
    final showPrize = _flipAnimation.value >= 0.5;
    if (showPrize != _showPrize) {
      setState(() => _showPrize = showPrize);
    }
  }

  @override
  void didUpdateWidget(covariant BingoCapTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealed && !oldWidget.revealed) {
      _flipController.forward();
    } else if (!widget.revealed && oldWidget.revealed) {
      _flipController.reverse();
    }
  }

  @override
  void dispose() {
    _flipController.removeListener(_onFlipTick);
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angle = widget.jiggling ? math.sin(widget.jigglePhase * math.pi * 2) * 0.1 : 0.0;
    final offsetX = widget.jiggling ? math.sin(widget.jigglePhase * math.pi * 4) * 6 : 0.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final t = _flipAnimation.value;
          final flipAngle = t * math.pi;
          final displayAngle = t >= 0.5 ? flipAngle - math.pi : flipAngle;
          return Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.rotate(
              angle: angle,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateY(displayAngle),
                child: child,
              ),
            ),
          );
        },
        child: Image.asset(
          _showPrize ? widget.prize.assetPath : '${AssetPaths.bingoImages}closed.png',
          width: BingoLayout.capWidth,
          height: BingoLayout.capHeight,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
