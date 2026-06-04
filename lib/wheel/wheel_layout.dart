abstract final class WheelLayout {
  static const double barHeight = 960;
  static const double barTop = 1160;
  static const double indicatorWidth = 180;
  static const double indicatorHeight = 100;
  static const double indicatorGap = 16;
  static const double spinButtonWidth = 880;
  static const double spinButtonBottom = 320;

  // 3D carousel — 3 cards visible with gap between them
  static const double cardWidth = 700;
  static const double cardHeight = 860;
  /// Horizontal distance between card centers (must be > cardWidth for gaps).
  static const double slotWidth = 840;
  static const double cardGap = slotWidth - cardWidth;

  static const double carouselPerspective = 0.0016;
  static const double carouselRotateY = 0.58;
  static const double carouselScaleFalloff = 0.1;
  static const double carouselOpacityFalloff = 0.22;
  static const double carouselMinScale = 0.9;
  static const double carouselSideOpacity = 0.78;
  static const double carouselDepthZ = 80;

  static const double cardBorderRadius = 48;
  static const double cardPadding = 40;
  static const double cardTitleFontSize = 68;

  static const double resultTitleFontSize = 96;
  static const double resultBodyFontSize = 52;
}
