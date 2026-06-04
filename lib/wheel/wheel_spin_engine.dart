import 'dart:math';

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
    return (prize: prize, index: index < 0 ? 0 : index);
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
  }

  int remainingTotal(WheelPrize prize) =>
      prize.maxTotal - (_totalWins[prize.id] ?? 0);
}
