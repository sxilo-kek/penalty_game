import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:penalty_game/wheel/widgets/fortune_bar_3d.dart';
import 'package:penalty_game/wheel/widgets/prize_card.dart';
import 'package:penalty_game/wheel/models/wheel_prize.dart';
import 'package:penalty_game/wheel/wheel_spin_engine.dart';
import 'package:penalty_game/wheel/wheel_layout.dart';
import 'package:penalty_game/kiosk_screen_size.dart';
import 'package:penalty_game/asset_paths.dart';

class FortuneWheelCarousel extends StatefulWidget {
  const FortuneWheelCarousel({super.key, required this.engine, required this.spinDurationMs, required this.minRotations});

  final WheelSpinEngine engine;
  final int spinDurationMs;
  final int minRotations;

  @override
  State<FortuneWheelCarousel> createState() => _FortuneWheelCarouselState();
}

class _FortuneWheelCarouselState extends State<FortuneWheelCarousel> {
  final StreamController<int> _selected = StreamController<int>.broadcast();

  bool _spinning = false;
  WheelPrize? _pendingWinner;

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  void _spin() {
    if (_spinning || widget.engine.prizes.isEmpty) return;

    final result = widget.engine.pickWinnerWithIndex();
    _pendingWinner = result.prize;
    _selected.add(result.index);
  }

  void _onAnimationEnd() {
    final winner = _pendingWinner;
    if (winner != null) {
      widget.engine.recordWin(winner);
    }
    if (mounted) {
      setState(() => _spinning = false);
      _showResult(winner);
    }
  }

  void _showResult(WheelPrize? prize) {
    if (prize == null || !mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => Center(
        child: GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            child: SizedBox(
              width: KioskScreenSize.width * WheelLayout.resultDialogWidthFactor,
              height: KioskScreenSize.height * WheelLayout.resultDialogHeightFactor,
              child: Padding(
                padding: const EdgeInsets.all(WheelLayout.resultDialogPadding),
                child: Image.asset('${AssetPaths.wheelImages}${prize.image}', fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<FortuneItem> _buildItems() {
    return [
      for (final prize in widget.engine.prizes)
        FortuneItem(
          child: SizedBox(
            width: WheelLayout.cardWidth,
            height: WheelLayout.cardHeight,
            child: PrizeCard(prize: prize),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: KioskScreenSize.width,
      height: KioskScreenSize.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            '${AssetPaths.wheelImages}wheel_background.png',
            width: KioskScreenSize.width,
            height: KioskScreenSize.height,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: WheelLayout.barTop,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('${AssetPaths.wheelImages}top_indicator.png', width: WheelLayout.indicatorWidth, height: WheelLayout.indicatorHeight, fit: BoxFit.contain),
                const SizedBox(height: WheelLayout.indicatorGap),
                FortuneBar3D(
                  selected: _selected.stream,
                  items: _buildItems(),
                  height: WheelLayout.barHeight,
                  fullWidth: true,
                  visibleItemCount: 3,
                  rotationCount: widget.minRotations,
                  duration: Duration(milliseconds: widget.spinDurationMs),
                  animateFirst: false,
                  curve: FortuneCurve.spin,
                  onAnimationStart: () => setState(() => _spinning = true),
                  onAnimationEnd: _onAnimationEnd,
                ),
                const SizedBox(height: WheelLayout.indicatorGap),
                Image.asset(
                  '${AssetPaths.wheelImages}bottom_indicator.png',
                  width: WheelLayout.indicatorWidth,
                  height: WheelLayout.indicatorHeight,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: WheelLayout.spinButtonBottom,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _spinning ? null : _spin,
                child: Opacity(
                  opacity: _spinning ? 0.55 : 1,
                  child: Image.asset(
                    '${AssetPaths.wheelImages}start_button.png',
                    width: WheelLayout.spinButtonWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
