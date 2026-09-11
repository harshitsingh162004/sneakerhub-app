import 'package:flutter/material.dart';

class AppConstants {
  // API URLs
  static const String baseUrl = 'http://3.108.236.130:8081';
  static const String wsUrl = 'http://3.108.236.130:8081/ws/websocket';

  // App Colors
  static const Color bgDark = Color(0xFF050B18);
  static const Color navyBlue = Color(0xFF0A1628);
  static const Color darkBlue = Color(0xFF0D1F3C);
  static const Color cardBlue = Color(0xFF0F2040);
  static const Color electricBlue = Color(0xFF1E6FFF);
  static const Color neonBlue = Color(0xFF00A3FF);
  static const Color glowBlue = Color(0xFF0066FF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF8A9BB5);
  static const Color textLight = Color(0xFFCDD5E0);
  static const Color success = Color(0xFF00D4AA);
  static const Color danger = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFB347);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1628), Color(0xFF050B18)],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E6FFF), Color(0xFF00A3FF)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F2040), Color(0xFF0A1628)],
  );

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: textWhite,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textWhite,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textWhite,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textLight,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textGrey,
  );

  static const TextStyle priceText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: textWhite,
    letterSpacing: -0.5,
  );

  // Spacing
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Box shadows
  static List<BoxShadow> glowShadow = [
    BoxShadow(
      color: electricBlue.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
