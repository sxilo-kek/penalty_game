import 'package:flutter/material.dart';

/// Layout for `/guest` only — 1080×1920 canvas (independent of [KioskScreenSize]).
abstract final class GuestLayout {
  static const Color cocaRed = Color(0xFFE41E2B);
  static const Color stageRed = Color(0xFFC8102E);

  static const double canvasWidth = 1080;
  static const double canvasHeight = 1920;

  static const double formTop = canvasHeight * 0.34;
  static const double chartTop = canvasHeight * 0.44;

  static const double fieldWidth = canvasWidth * 0.83;
  static const double companyFieldHeight = 70;
  static const double nameFieldHeight = 70;
  static const double fieldFontSize = 32;
  static const double fieldRadius = 35;
  static const double fieldPaddingH = 24;
  static const double formFieldGap = 18;
  static const double whiteFieldRadius = 8;

  static const double chartWidth = canvasWidth * 0.85;
  static const double chartBorderRadius = 16;
  static const double chartPadding = 24;
  static const double chartSectionPaddingV = 18;
  static const double chartRowGap = 6;

  static const double tableSize = 75;
  static const double tableHighlightGrow = 10;
  static const double tableFontSize = 32;
  static const double tableHighlightBorder = 4;
  static const double stageBarHeight = 50;
  static const double stageFontSize = 26;
  static const double entryBarHeight = 40;
  static const double entryFontSize = 21;
  static const double entryPaddingH = 20;

  static const double suggestionFontSize = 24;
  static const double suggestionMaxHeight = 280;
  static const double suggestionBorderRadius = 12;
  static const double suggestionListPaddingV = 6;

  static const double errorFontSize = 24;

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
