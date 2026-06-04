abstract final class WheelLayout {
  static const double barHeight = 920;
  static const double barTop = 1180;
  static const double indicatorWidth = 180;
  static const double indicatorHeight = 100;
  static const double indicatorGap = 16;
  static const double spinButtonWidth = 880;
  static const double spinButtonBottom = 320;

  // 3D carousel (match reference: center flat, sides angled inward + faded)
  static const double slotWidth = 580;
  static const double cardWidth = 620;
  static const double cardHeight = 800;
  static const double carouselPerspective = 0.0018;
  /// Y rotation — sides tilt toward center (reference cover-flow).
  static const double carouselRotateY = 0.78;
  static const double carouselScaleFalloff = 0.18;
  static const double carouselOpacityFalloff = 0.38;
  static const double carouselMinScale = 0.78;
  static const double carouselSideOpacity = 0.62;
  static const double carouselDepthZ = 100;

  static const double cardBorderRadius = 48;
  static const double cardPadding = 36;
  static const double cardTitleFontSize = 64;

  static const double resultTitleFontSize = 96;
  static const double resultBodyFontSize = 52;
}
