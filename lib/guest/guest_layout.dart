import 'package:flutter/material.dart';

import 'package:penalty_game/kiosk_screen_size.dart';

/// Layout tuned for [KioskScreenSize] — same 2160×3840 canvas as penalty & wheel.
abstract final class GuestLayout {
  static const Color cocaRed = Color(0xFFE41E2B);
  static const Color stageRed = Color(0xFFC8102E);

  static const double formTop = KioskScreenSize.height * 0.34;
  static const double chartTop = KioskScreenSize.height * 0.44;

  static const double fieldWidth = KioskScreenSize.width * 0.83;
  static const double companyFieldHeight = 140;
  static const double nameFieldHeight = 140;
  static const double fieldFontSize = 64;
  static const double fieldRadius = 70;

  static const double chartWidth = KioskScreenSize.width * 0.85;
  static const double chartPadding = 48;
  static const double tableSize = 150;
  static const double tableFontSize = 64;
  static const double stageBarHeight = 100;
  static const double stageFontSize = 52;
  static const double entryBarHeight = 80;
  static const double entryFontSize = 42;
  static const double suggestionFontSize = 48;

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
