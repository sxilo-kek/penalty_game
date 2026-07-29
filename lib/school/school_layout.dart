import 'package:flutter/material.dart';

abstract final class SchoolLayout {
  // Colors — soft pink/cream/coral palette matching the reference design.
  static const Color background = Color(0xFFFDF5F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFE8766A);
  static const Color accentLight = Color(0xFFFCEAE8);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textMuted = Color(0xFF888888);
  static const Color divider = Color(0xFFEEE5E0);
  static const Color badge = Color(0xFFFF9A8B);
  static const Color badgeText = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x14000000);
  static const Color priceStrike = Color(0xFFBBBBBB);
  static const Color headerGradientStart = Color(0xFFF5A399);
  static const Color headerGradientEnd = Color(0xFFE87C6B);
  static const Color iconBg = Color(0xFFFCEAE8);

  // Typography
  static const double headerTitleSize = 28;
  static const double headerSubtitleSize = 14;
  static const double schoolNameSize = 20;
  static const double schoolDescSize = 14;
  static const double courseTitleSize = 14;
  static const double priceSize = 18;
  static const double priceSizeSmall = 13;
  static const double badgeFontSize = 12;
  static const double sectionLabelSize = 12;
  static const double metaSize = 13;

  // Spacing
  static const double pagePadding = 24;
  static const double gridGap = 20;
  static const double cardRadius = 20;
  static const double cardPadding = 20;
  static const double badgeRadius = 20;
  static const double courseRowPad = 12;
  static const double iconSize = 18;
  static const double avatarSize = 64;

  // Responsive breakpoints
  static const double twoColumnBreakpoint = 700;

  // Header
  static const double headerHeight = 160;
}
