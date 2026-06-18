import 'package:flutter/material.dart';

class AppColors {
  static const Color cream = Color(0xFFFFFBF4);
  static const Color warmIvory = Color(0xFFFFF7EC);
  static const Color softPink = Color(0xFFFFDDE8);
  static const Color blush = Color(0xFFFFEFF4);
  static const Color softYellow = Color(0xFFFFF0BE);
  static const Color softPeach = Color(0xFFFFE4D6);
  static const Color softBeige = Color(0xFFF3E8D7);
  static const Color sky = Color(0xFFDDF0FF);
  static const Color lavender = Color(0xFFE9E2FF);
  static const Color mint = Color(0xFFE4F6EE);

  static const Color navy = Color(0xFF26364A);
  static const Color dustyRose = Color(0xFFC8798D);
  static const Color textDark = Color(0xFF2F3747);
  static const Color textBrown = Color(0xFF6B5D57);
  static const Color textLight = Color(0xFF968B88);
  static const Color line = Color(0xFFECE1D6);

  static const Color white = Colors.white;
}

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const double screenHorizontal = 20;
  static const double cardRadius = 28;
  static const double heroRadius = 32;
  static const double buttonRadius = 18;
  static const double cardPadding = 22;

  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(
    screenHorizontal,
    xs,
    screenHorizontal,
    xl,
  );
}

class AppRadii {
  static const double chip = 999;
  static const double button = 18;
  static const double compactCard = 22;
  static const double card = 28;
  static const double heroCard = 32;
}

class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: 0.07),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.softPink,
      brightness: Brightness.light,
      primary: AppColors.navy,
      secondary: AppColors.dustyRose,
      surface: AppColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.navy,
      unselectedItemColor: AppColors.textLight,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        height: 1.22,
        letterSpacing: -0.6,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.3,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.32,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 17,
        fontWeight: FontWeight.w800,
        height: 1.35,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textBrown,
        fontSize: 16,
        height: 1.58,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textBrown,
        fontSize: 14,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: AppColors.textLight,
        fontSize: 12,
        height: 1.45,
      ),
      labelLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
      labelMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        ),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: AppColors.navy, width: 1.4),
      ),
    ),
  );
}
