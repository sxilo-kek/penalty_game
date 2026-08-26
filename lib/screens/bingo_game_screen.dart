import 'package:flutter/material.dart';
import 'dart:math';

import 'package:penalty_game/bingo/widgets/bingo_confetti.dart';
import 'package:penalty_game/bingo/widgets/bingo_grid.dart';
import 'package:penalty_game/widgets/kiosk_canvas.dart';
import 'package:penalty_game/bingo/bingo_layout.dart';
import 'package:penalty_game/bingo/bingo_prize.dart';
import 'package:penalty_game/asset_paths.dart';

class BingoGameScreen extends StatefulWidget {
  const BingoGameScreen({super.key});

  @override
  State<BingoGameScreen> createState() => _BingoGameScreenState();
}

class _BingoGameScreenState extends State<BingoGameScreen> with SingleTickerProviderStateMixin {
  final Random _random = Random();

  late List<BingoPrize> _prizes;
  late List<bool> _revealed;
  late final AnimationController _jiggleController;

  bool _hasPicked = false;
  bool _isResetting = false;
  int? _pickedIndex;
  int _confettiKey = 0;

  @override
  void initState() {
    super.initState();
    _jiggleController = AnimationController(
      vsync: this,
      duration: BingoLayout.jiggleDuration,
    );
    _jiggleController.repeat();
    _shuffleBoard();
  }

  @override
  void dispose() {
    _jiggleController.dispose();
    super.dispose();
  }

  void _shuffleBoard() {
    final prizes = <BingoPrize>[
      ...List.filled(6, BingoPrize.drink),
      ...List.filled(3, BingoPrize.thankyou),
    ]..shuffle(_random);

    _prizes = prizes;
    _revealed = List<bool>.filled(BingoLayout.capCount, false);
    _hasPicked = false;
    _isResetting = false;
    _pickedIndex = null;
  }

  Future<void> _onCapTap(int index) async {
    if (_isResetting) return;

    if (_hasPicked) {
      await _resetRound();
      return;
    }

    setState(() {
      _hasPicked = true;
      _pickedIndex = index;
      _revealed[index] = true;
      _jiggleController.stop();
      if (_prizes[index].isWinning) {
        _confettiKey++;
      }
    });
  }

  Future<void> _resetRound() async {
    setState(() {
      _isResetting = true;
      _revealed = List<bool>.filled(BingoLayout.capCount, false);
      _pickedIndex = null;
    });

    await Future<void>.delayed(BingoLayout.flipDuration);
    if (!mounted) return;

    setState(() {
      _shuffleBoard();
      _jiggleController.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KioskCanvas(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    final showConfetti = _hasPicked && _pickedIndex != null && _prizes[_pickedIndex!].isWinning;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          '${AssetPaths.bingoImages}background.png',
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
        AnimatedBuilder(
          animation: _jiggleController,
          builder: (context, _) {
            return BingoGrid(
              prizes: _prizes,
              revealed: _revealed,
              jiggling: !_hasPicked && !_isResetting,
              jiggleValue: _jiggleController.value,
              showPrizeLabels: BingoLayout.showPrizeLabels,
              onCapTap: _onCapTap,
            );
          },
        ),
        if (showConfetti)
          BingoConfetti(
            key: ValueKey(_confettiKey),
            origin: BingoLayout.capCenter(_pickedIndex!),
          ),
      ],
    );
  }
}
