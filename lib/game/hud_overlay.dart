import 'package:flutter/material.dart';

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
  int prevSaves = 0;

  @override
  void initState() {
    super.initState();
    scoreAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goals
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.35)
                          .chain(CurveTween(curve: Curves.elasticOut))
                          .animate(scoreAnim),
                      child: Text(
                        game.score.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const Text(
                      'Goals',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Level badge
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lv ${game.difficultyLevel + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const Text(
                      'Level',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
