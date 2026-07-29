import 'package:flutter/material.dart';

import 'package:penalty_game/bingo/bingo_layout.dart';
import 'package:penalty_game/bingo/bingo_prize.dart';
import 'package:penalty_game/bingo/widgets/bingo_cap_tile.dart';

class BingoGrid extends StatelessWidget {
  const BingoGrid({
    super.key,
    required this.prizes,
    required this.revealed,
    required this.jiggling,
    required this.jiggleValue,
    required this.showPrizeLabels,
    required this.onCapTap,
  });

  final List<BingoPrize> prizes;
  final List<bool> revealed;
  final bool jiggling;
  final double jiggleValue;
  final bool showPrizeLabels;
  final ValueChanged<int> onCapTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < BingoLayout.capCount; i++)
          Positioned(
            left: BingoLayout.capTopLeft(i).dx,
            top: BingoLayout.capTopLeft(i).dy,
            width: BingoLayout.capWidth,
            height: BingoLayout.capHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                BingoCapTile(
                  prize: prizes[i],
                  revealed: revealed[i],
                  jiggling: jiggling,
                  jigglePhase: (jiggleValue + i * 0.11) % 1.0,
                  onTap: () => onCapTap(i),
                ),
                if (showPrizeLabels)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -72,
                    child: Text(
                      prizes[i].debugLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
