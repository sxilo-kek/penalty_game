import 'package:flutter/material.dart';

import 'package:penalty_game/kiosk_screen_size.dart';

/// Layout for `/bingo` on the [KioskScreenSize] canvas (2160×3840).
abstract final class BingoLayout {
  static const double canvasWidth = KioskScreenSize.width;
  static const double canvasHeight = KioskScreenSize.height;

  static const int columns = 3;
  static const int rows = 3;
  static const int capCount = columns * rows;

  static const double cardLeft = 180;
  static const double cardTop = 1104;
  static const double cardRight = 1998;
  static const double cardBottom = 3140;
  static const double gridPadding = 80;

  static const double capWidth = 460;
  static const double capHeight = 460;

  static const bool showPrizeLabels = false;

  static const Duration flipDuration = Duration(milliseconds: 420);
  static const Duration jiggleDuration = Duration(milliseconds: 900);
  static const Duration confettiDuration = Duration(milliseconds: 2800);

  static double get _gridLeft => cardLeft + gridPadding;
  static double get _gridTop => cardTop + gridPadding;
  static double get _gridWidth => cardRight - cardLeft - gridPadding * 2;
  static double get _gridHeight => cardBottom - cardTop - gridPadding * 2;
  static double get _cellWidth => _gridWidth / columns;
  static double get _cellHeight => _gridHeight / rows;

  static double colCenter(int col) => _gridLeft + _cellWidth * (col + 0.5);
  static double rowCenter(int row) => _gridTop + _cellHeight * (row + 0.5);

  static Offset capTopLeft(int index) {
    final col = index % columns;
    final row = index ~/ columns;
    return Offset(
      colCenter(col) - capWidth / 2,
      rowCenter(row) - capHeight / 2,
    );
  }

  static Offset capCenter(int index) {
    final col = index % columns;
    final row = index ~/ columns;
    return Offset(colCenter(col), rowCenter(row));
  }
}
