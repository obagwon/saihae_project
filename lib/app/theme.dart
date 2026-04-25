import 'package:flutter/material.dart';

class AppColors {
  static const Color cream = Color(0xFFFFFBF3);
  static const Color softPink = Color(0xFFFFDDE6);
  static const Color softYellow = Color(0xFFFFF1B8);
  static const Color softPeach = Color(0xFFFFE3D3);
  static const Color softBeige = Color(0xFFF3E7D3);

  static const Color textDark = Color(0xFF3F3A36);
  static const Color textBrown = Color(0xFF6F5E53);
  static const Color textLight = Color(0xFF9A8B82);

  static const Color white = Colors.white;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.softPink,
      brightness: Brightness.light,
      primary: AppColors.softPink,
      secondary: AppColors.softYellow,
      background: AppColors.cream,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textDark,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.textDark,
      unselectedItemColor: AppColors.textLight,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textBrown,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textBrown,
        fontSize: 14,
        height: 1.45,
      ),
      bodySmall: TextStyle(
        color: AppColors.textLight,
        fontSize: 12,
        height: 1.4,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textDark,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}