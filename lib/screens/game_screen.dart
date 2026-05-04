import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:penalty_game/game/penalty_game.dart';
import 'package:penalty_game/game/hud_overlay.dart';
import 'package:penalty_game/game/game_over_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final PenaltyGame _game;

  @override
  void initState() {
    super.initState();
    _game = PenaltyGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<PenaltyGame>(
        game: _game,
        overlayBuilderMap: {
          'hud': (_, g) => HudOverlay(game: g),
          'gameOver': (_, g) => GameOverOverlay(game: g),
        },
        initialActiveOverlays: const ['hud'],
      ),
    );
  }
}
