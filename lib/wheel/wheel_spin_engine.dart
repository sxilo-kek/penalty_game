import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:penalty_game/wheel/models/wheel_prize.dart';

/// Picks a prize using JSON [probability] weights and [maxTotal] excess limits.
class WheelSpinEngine {
  WheelSpinEngine(this.config) : _rng = Random();

  final WheelConfig config;
  final Random _rng;

  final Map<String, int> _totalWins = {};

  List<WheelPrize> get prizes => config.prizes;

  bool hasQuota(WheelPrize prize) {
    final total = _totalWins[prize.id] ?? 0;
    return total < prize.maxTotal;
  }

  ({WheelPrize prize, int index}) pickWinnerWithIndex() {
    final prize = pickWinner();
    final index = prizes.indexWhere((p) => p.id == prize.id);
    final safeIndex = index < 0 ? 0 : index;

    _logWinningReward(prize, safeIndex);
    _logExcess(label: 'before recordWin');

    return (prize: prize, index: safeIndex);
  }

  WheelPrize pickWinner() {
    final eligible = prizes.where(hasQuota).toList();
    if (eligible.isEmpty) {
      return prizes.last;
    }

    final totalWeight =
        eligible.fold<double>(0, (sum, p) => sum + p.probability);
    var roll = _rng.nextDouble() * totalWeight;

    for (final prize in eligible) {
      roll -= prize.probability;
      if (roll <= 0) return prize;
    }
    return eligible.last;
  }

  void recordWin(WheelPrize prize) {
    _totalWins[prize.id] = (_totalWins[prize.id] ?? 0) + 1;
    _logExcess(label: 'after recordWin');
  }

  int remainingTotal(WheelPrize prize) =>
      prize.maxTotal - (_totalWins[prize.id] ?? 0);

  void _logWinningReward(WheelPrize prize, int index) {
    debugPrint(
      '[Wheel] Winning reward: id=${prize.id}, title=${prize.title}, '
      'index=$index, probability=${prize.probability}',
    );
  }

  void _logExcess({required String label}) {
    final buffer = StringBuffer('[Wheel] Excess ($label):\n');
    for (final prize in prizes) {
      final won = _totalWins[prize.id] ?? 0;
      final remaining = prize.maxTotal - won;
      buffer.writeln(
        '  ${prize.id}: won=$won, remaining=$remaining, maxTotal=${prize.maxTotal}, '
        'eligible=${remaining > 0}',
      );
    }
    debugPrint(buffer.toString());
  }
}
