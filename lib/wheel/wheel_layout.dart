import 'package:penalty_game/kiosk_screen_size.dart';

/// Wheel UI layout tuned for [KioskScreenSize] (same canvas as penalty game).
abstract final class WheelLayout {
  static const double barHeight = 920;
  static const double barTop = 1180;
  static const double indicatorWidth = 180;
  static const double spinButtonWidth = 880;
  static const double spinButtonBottom = 320;

  static const double cardBorderRadius = 56;
  static const double cardPadding = 40;
  static const double cardTitleFontSize = 72;

  static const double resultTitleFontSize = 96;
  static const double resultBodyFontSize = 52;
}
