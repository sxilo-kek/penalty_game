import 'package:flutter/material.dart';
import 'dart:math';

import 'package:penalty_game/asset_paths.dart';
import 'package:penalty_game/bingo/bingo_layout.dart';
import 'package:penalty_game/bingo/bingo_prize.dart';
import 'package:penalty_game/bingo/widgets/bingo_grid.dart';
import 'package:penalty_game/widgets/kiosk_canvas.dart';

class BingoGameScreen extends StatefulWidget {
  const BingoGameScreen({super.key});

  @override
  State<BingoGameScreen> createState() => _BingoGameScreenState();
}

class _BingoGameScreenState extends State<BingoGameScreen> {
  final Random _random = Random();

  late List<BingoPrize?> _prizes;
  late List<bool> _revealed;

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    _prizes = List<BingoPrize?>.filled(BingoLayout.capCount, null);
    _revealed = List<bool>.filled(BingoLayout.capCount, false);
  }

  void _onCapTap(int index) {
    if (_revealed[index]) return;

    setState(() {
      _prizes[index] =
          _random.nextBool() ? BingoPrize.drink : BingoPrize.gift;
      _revealed[index] = true;
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          '${AssetPaths.bingoImages}background.png',
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
        const Positioned(
          top: BingoLayout.pickOneTop,
          left: 0,
          right: 0,
          child: Text(
            'pick one',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: BingoLayout.pickOneFontSize,
              color: BingoLayout.pickOneColor,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
              height: 1,
            ),
          ),
        ),
        BingoGrid(
          prizes: _prizes,
          revealed: _revealed,
          onCapTap: _onCapTap,
        ),
      ],
    );
  }
}
