import 'package:flutter/material.dart';

import 'package:penalty_game/kiosk_screen_size.dart';

/// Layout for `/bingo` on the [KioskScreenSize] canvas (2160×3840).
/// Cap centers scaled from the 576×1024 concept art (×3.75).
abstract final class BingoLayout {
  static const double canvasWidth = KioskScreenSize.width;
  static const double canvasHeight = KioskScreenSize.height;

  static const int columns = 3;
  static const int rows = 3;
  static const int capCount = columns * rows;

  static const double capWidth = 420;
  static const double capHeight = 432;

  /// Column center X positions.
  static const List<double> colCenters = [480, 1080, 1672.5];

  /// Row center Y positions.
  static const List<double> rowCenters = [1530, 2152.5, 2771.25];

  static const double pickOneFontSize = 52;
  static const Color pickOneColor = Color(0xFFB8B8B8);
  static const double pickOneTop = 1106;

  static const Duration flipDuration = Duration(milliseconds: 420);

  static Offset capTopLeft(int index) {
    final col = index % columns;
    final row = index ~/ columns;
    return Offset(
      colCenters[col] - capWidth / 2,
      rowCenters[row] - capHeight / 2,
    );
  }
}
