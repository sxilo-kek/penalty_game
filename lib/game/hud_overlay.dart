import 'package:flutter/material.dart';

import 'package:penalty_game/kiosk_screen_size.dart';
import 'package:penalty_game/game/penalty_game.dart';

class HudOverlay extends StatefulWidget {
  final PenaltyGame game;
  const HudOverlay({super.key, required this.game});

  @override
  State<HudOverlay> createState() => _HudOverlayState();
}

class _HudOverlayState extends State<HudOverlay> with TickerProviderStateMixin {
  late AnimationController scoreAnim;
  int prevScore = 0;

  @override
  void initState() {
    super.initState();
    scoreAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    widget.game.onScoreChanged = () {
      if (!mounted) return;
      setState(() {});
      if (widget.game.score != prevScore) {
        scoreAnim.forward(from: 0);
        prevScore = widget.game.score;
      }
    };
  }

  @override
  void dispose() {
    scoreAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / KioskScreenSize.width;
        final hPad = KioskScreenSize.width * 0.03 * scale;
        final bottomPad = KioskScreenSize.height * 0.025 * scale;
        final valueSize = 72.0 * scale;
        final labelSize = 36.0 * scale;
        final badgePadH = 48.0 * scale;
        final badgePadV = 28.0 * scale;
        final radius = 24.0 * scale;

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, bottomPad),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HudBadge(
                  value: game.score.toString(),
                  label: 'Goals',
                  scale: scoreAnim,
                  valueSize: valueSize,
                  labelSize: labelSize,
                  paddingH: badgePadH,
                  paddingV: badgePadV,
                  radius: radius,
                ),
                _HudBadge(
                  value: 'Lv ${game.difficultyLevel + 1}',
                  label: 'Level',
                  valueSize: valueSize,
                  labelSize: labelSize,
                  paddingH: badgePadH,
                  paddingV: badgePadV,
                  radius: radius,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HudBadge extends StatelessWidget {
  const _HudBadge({
    required this.value,
    required this.label,
    required this.valueSize,
    required this.labelSize,
    required this.paddingH,
    required this.paddingV,
    required this.radius,
    this.scale,
  });

  final String value;
  final String label;
  final double valueSize;
  final double labelSize;
  final double paddingH;
  final double paddingV;
  final double radius;
  final Animation<double>? scale;

  @override
  Widget build(BuildContext context) {
    final valueText = Text(
      value,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: valueSize,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (scale != null)
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.35)
                  .chain(CurveTween(curve: Curves.elasticOut))
                  .animate(scale!),
              child: valueText,
            )
          else
            valueText,
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: labelSize),
          ),
        ],
      ),
    );
  }
}
