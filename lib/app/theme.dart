import 'package:flutter/material.dart';

class AppColors {
  static const Color cream = Color(0xFFFFF8ED);
  static const Color creamDeep = Color(0xFFFFF1DE);
  static const Color blush = Color(0xFFFF7E8E);
  static const Color blushDark = Color(0xFFFF6D7D);
  static const Color softPink = Color(0xFFFFD5D9);
  static const Color softYellow = Color(0xFFFFE6A6);
  static const Color softPeach = Color(0xFFFFE0D1);
  static const Color softBeige = Color(0xFFEFE0CC);
  static const Color lavender = Color(0xFFE9D7FF);

  static const Color textDark = Color(0xFF332521);
  static const Color textBrown = Color(0xFF7D5549);
  static const Color textLight = Color(0xFFA9958B);
  static const Color line = Color(0xFFF0DDD1);

  static const Color white = Colors.white;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blush,
      brightness: Brightness.light,
      primary: AppColors.blush,
      secondary: AppColors.softYellow,
      background: AppColors.cream,
      surface: AppColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.blush,
      unselectedItemColor: AppColors.textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
      unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.blush, width: 1.4),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        height: 1.25,
        letterSpacing: -0.7,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        height: 1.28,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 15,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.1,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textBrown,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textBrown,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: AppColors.textLight,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.45,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blush,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: AppColors.blush.withOpacity(0.28),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}
