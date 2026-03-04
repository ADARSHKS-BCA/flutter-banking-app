import 'package:flutter/material.dart';

class AppColors {
  // Primary palette (Dark Theme)
  static const Color primaryBlue = Color(0xFF6C63FF); // Vibrant indigo
  static const Color secondaryBlue = Color(0xFF3F3D56); // Deep muted purple
  static const Color accentCyan = Color(0xFF00E5FF); // Neon cyan
  static const Color accentPink = Color(0xFFFF69B4); // Neon pink

  // Surface & background
  static const Color background = Color(0xFF0F1014); // Deep obsidian black
  static const Color surface = Color(0xFF1C1D26); // Elevated dark surface
  static const Color surfaceVariant = Color(0xFF252736); // Lighter elevated surface
  static const Color cardDark = Color(0xFF14151C); // Card background

  // Text
  static const Color textDark = Color(0xFFFFFFFF); // White text for dark mode
  static const Color textLight = Color(0xFFB0B3C6); // Light gray for secondary text
  static const Color textHint = Color(0xFF75788D); // Deeper gray

  // Semantic
  static const Color success = Color(0xFF00E676); // Neon green
  static const Color error = Color(0xFFFF3D00); // Neon red
  static const Color warning = Color(0xFFFFD600); // Neon yellow
  static const Color info = Color(0xFF29B6F6);

  // Glass
  static const Color glassBorder = Color(0x30FFFFFF);
  static const Color glassBackground = Color(0x15FFFFFF);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D65FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryVertical = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF0F1014)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient card = LinearGradient(
    colors: [Color(0xFF252736), Color(0xFF1C1D26)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Bank Card Gradient (Stunning deep purple to dark blue)
  static const LinearGradient bankCard = LinearGradient(
    colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF64DD17)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient withdraw = LinearGradient(
    colors: [Color(0xFFFF9100), Color(0xFFFF3D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient button = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00E5FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient splash = LinearGradient(
    colors: [Color(0xFF0F1014), Color(0xFF1A1A2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> cardHover = [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.3),
      blurRadius: 30,
      offset: const Offset(0, 15),
    ),
  ];

  static List<BoxShadow> button = [
    BoxShadow(
      color: AppColors.primaryBlue.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> glow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.5),
      blurRadius: 30,
      offset: const Offset(0, 0),
      spreadRadius: 5,
    ),
  ];

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(milliseconds: 800);
}

class AppTextStyles {
  static const TextStyle display = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
    letterSpacing: -1.0,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0.2,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    color: AppColors.textLight,
    height: 1.6,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    color: AppColors.textHint,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
  );

  static const TextStyle balanceLarge = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: -1.5,
  );
}
