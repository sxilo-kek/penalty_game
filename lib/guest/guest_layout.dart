import 'package:flutter/material.dart';

import 'package:penalty_game/kiosk_screen_size.dart';

/// Layout for `/guest` on the same [KioskScreenSize] canvas as penalty & wheel.
abstract final class GuestLayout {
  static const Color cocaRed = Color(0xFFE41E2B);
  static const Color stageRed = Color(0xFFC8102E);

  static const double canvasWidth = KioskScreenSize.width;
  static const double canvasHeight = KioskScreenSize.height;

  static const double formTop = canvasHeight * 0.34;
  static const double chartTop = canvasHeight * 0.44;

  static const double fieldWidth = canvasWidth * 0.83;
  static const double companyFieldHeight = 140;
  static const double nameFieldHeight = 140;
  static const double fieldFontSize = 64;
  static const double fieldRadius = 70;
  static const double fieldPaddingH = 48;
  static const double formFieldGap = 36;
  static const double whiteFieldRadius = 16;

  static const double chartWidth = canvasWidth * 0.85;
  static const double chartBorderRadius = 32;
  static const double chartPadding = 48;
  static const double chartSectionPaddingV = 36;
  static const double chartRowGap = 12;

  static const double tableSize = 150;
  static const double tableHighlightGrow = 20;
  static const double tableFontSize = 64;
  static const double tableHighlightBorder = 8;
  static const double stageBarHeight = 100;
  static const double stageFontSize = 52;
  static const double entryBarHeight = 80;
  static const double entryFontSize = 42;
  static const double entryPaddingH = 40;

  static const double suggestionFontSize = 48;
  static const double suggestionMaxHeight = 560;
  static const double suggestionBorderRadius = 24;
  static const double suggestionListPaddingV = 12;

  static const double errorFontSize = 48;

  /// Seating grid — `null` = empty cell (matches event floor plan).
  static const List<List<int?>> seatingGrid = [
    [null, 8, null, null, 7, null],
    [16, null, 6, 5, null, 15],
    [null, 12, null, null, 11, null],
    [20, null, 2, 1, null, 19],
    [null, 14, null, null, 13, null],
    [22, null, 4, 3, null, 21],
    [null, 18, null, null, 17, null],
    [24, null, 10, 9, null, 23],
    [null, 26, null, null, 25, null],
  ];
}
