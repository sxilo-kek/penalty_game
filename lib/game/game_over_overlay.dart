import 'package:flutter/material.dart';

import 'package:penalty_game/game/penalty_game.dart';

class GameOverOverlay extends StatefulWidget {
  final PenaltyGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> with SingleTickerProviderStateMixin {
  late AnimationController ctrl;
  late Animation<double> scale, fade;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    scale = CurvedAnimation(parent: ctrl, curve: Curves.elasticOut);
    fade = CurvedAnimation(parent: ctrl, curve: Curves.easeIn);
    ctrl.forward();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void _restart() {
    // Remove overlay and reset game state
    widget.game.overlays.remove('gameOver');
    widget.game.isGameOver = false;
    widget.game.saves = 0;
    // Reset internal score via a fresh SecureScore isn't public, so we
    // recreate the whole game by calling a restart helper instead.
    widget.game.restartGame();
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.game;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: fade,
      child: Material(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: ScaleTransition(
            scale: scale,
            child: SizedBox(
              width: sw * 0.85,
              height: sh * 0.60, // was 0.50
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60), // was 24
                child: Stack(
                  children: [
                    Container(color: const Color(0xffF40000)),
                    Column(
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(30), // was 10
                            child: GestureDetector(
                              onTap: _restart,
                              child: Container(
                                width: 100, height: 100, // was 34/34
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.close, color: Colors.black, size: 60), // was 18
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Game Over!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 120, // was 32
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Try again and score more goals!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w300,
                              fontSize: 52, // was 16
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Score badge
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(60)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.sports_soccer, size: 120, color: Colors.black), // was 40
                              const SizedBox(width: 40),
                              Text(
                                g.score.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 180, // was 60
                                    fontWeight: FontWeight.w700,
                                    height: 1.1),
                              ),
                              const SizedBox(width: 40),
                              const Text('Goals',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 100, // was 32
                                      fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Play again button
                        GestureDetector(
                          onTap: _restart,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40), // was 32/12
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              'Play Again',
                              style: TextStyle(
                                  color: Color(0xffF40000),
                                  fontSize: 72, // was 18
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
