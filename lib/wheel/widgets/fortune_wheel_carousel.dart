import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:penalty_game/asset_paths.dart';
import 'package:penalty_game/kiosk_screen_size.dart';
import 'package:penalty_game/wheel/models/wheel_prize.dart';
import 'package:penalty_game/wheel/wheel_layout.dart';
import 'package:penalty_game/wheel/wheel_spin_engine.dart';
import 'package:penalty_game/wheel/widgets/fortune_bar_3d.dart';
import 'package:penalty_game/wheel/widgets/prize_card.dart';

class FortuneWheelCarousel extends StatefulWidget {
  const FortuneWheelCarousel({
    super.key,
    required this.engine,
    required this.spinDurationMs,
    required this.minRotations,
  });

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
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xffF40000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        title: Text(
          prize.id == 'thanks' ? 'Баярлалаа' : 'Баяр хүргэе!',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: WheelLayout.resultTitleFontSize,
          ),
        ),
        content: Text(
          prize.title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: WheelLayout.resultBodyFontSize,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 48),
            ),
          ),
        ],
      ),
    );
  }

  List<FortuneItem> _buildItems() {
    return [
      for (final prize in widget.engine.prizes)
        FortuneItem(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SizedBox(
              width: WheelLayout.cardWidth,
              height: WheelLayout.cardHeight,
              child: PrizeCard(prize: prize),
            ),
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
