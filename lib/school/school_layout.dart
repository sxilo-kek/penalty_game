import 'package:flutter/material.dart';

abstract final class SchoolLayout {
  static const Color primary = Color(0xFF4A7CDE);
  static const Color primaryLight = Color(0xFFE8F0FE);
  static const Color primaryDark = Color(0xFF3560B8);
  static const Color background = Color(0xFFF5F8FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textMuted = Color(0xFF8E99A4);
  static const Color divider = Color(0xFFE8ECF2);
  static const Color badge = Color(0xFF4A7CDE);
  static const Color badgeText = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x0C4A7CDE);
  static const Color priceStrike = Color(0xFFBBBBBB);
  static const Color discountPrice = Color(0xFF4A7CDE);

  static const String logoPath = 'assets/images/school/logo.jpg';

  static const double headerTitleSize = 24;
  static const double headerSubtitleSize = 13;
  static const double schoolNameSize = 17;
  static const double schoolDescSize = 13;
  static const double courseTitleSize = 14;
  static const double priceSize = 16;
  static const double priceSizeSmall = 12;
  static const double badgeFontSize = 11;
  static const double sectionLabelSize = 11;
  static const double metaSize = 13;

  static const double pagePadding = 20;
  static const double gridGap = 16;
  static const double cardRadius = 16;
  static const double cardPadding = 16;
  static const double badgeRadius = 20;
  static const double courseRowPad = 12;
  static const double iconSize = 16;
  static const double cardImageHeight = 140;

  static const double twoColumnBreakpoint = 700;
  static const double threeColumnBreakpoint = 1080;
}
