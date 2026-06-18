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


class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color card;
  final Color cardMuted;
  final Color hero;
  final Color blush;
  final Color sky;
  final Color lavender;
  final Color peach;
  final Color mint;
  final Color notice;
  final Color primary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color line;
  final Color shadow;

  const AppPalette({
    required this.background,
    required this.card,
    required this.cardMuted,
    required this.hero,
    required this.blush,
    required this.sky,
    required this.lavender,
    required this.peach,
    required this.mint,
    required this.notice,
    required this.primary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.line,
    required this.shadow,
  });

  static const light = AppPalette(
    background: AppColors.cream,
    card: AppColors.white,
    cardMuted: AppColors.warmIvory,
    hero: AppColors.warmIvory,
    blush: AppColors.blush,
    sky: AppColors.sky,
    lavender: AppColors.lavender,
    peach: AppColors.softPeach,
    mint: AppColors.mint,
    notice: Color(0xFCFFFFFF),
    primary: AppColors.navy,
    accent: AppColors.dustyRose,
    textPrimary: AppColors.textDark,
    textSecondary: AppColors.textBrown,
    textMuted: AppColors.textLight,
    line: AppColors.line,
    shadow: Color(0x1226364A),
  );

  static const dark = AppPalette(
    background: Color(0xFF211D24),
    card: Color(0xFF302A33),
    cardMuted: Color(0xFF3A3031),
    hero: Color(0xFF3A302D),
    blush: Color(0xFF4A313C),
    sky: Color(0xFF283847),
    lavender: Color(0xFF39324A),
    peach: Color(0xFF4A352D),
    mint: Color(0xFF2C4039),
    notice: Color(0xFF2A2630),
    primary: Color(0xFFF6D7E0),
    accent: Color(0xFFE7A6B6),
    textPrimary: Color(0xFFF7EEF1),
    textSecondary: Color(0xFFE1D1D0),
    textMuted: Color(0xFFBBAEAF),
    line: Color(0xFF4A4148),
    shadow: Color(0x66000000),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? card,
    Color? cardMuted,
    Color? hero,
    Color? blush,
    Color? sky,
    Color? lavender,
    Color? peach,
    Color? mint,
    Color? notice,
    Color? primary,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? line,
    Color? shadow,
  }) {
    return AppPalette(
      background: background ?? this.background,
      card: card ?? this.card,
      cardMuted: cardMuted ?? this.cardMuted,
      hero: hero ?? this.hero,
      blush: blush ?? this.blush,
      sky: sky ?? this.sky,
      lavender: lavender ?? this.lavender,
      peach: peach ?? this.peach,
      mint: mint ?? this.mint,
      notice: notice ?? this.notice,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      line: line ?? this.line,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardMuted: Color.lerp(cardMuted, other.cardMuted, t)!,
      hero: Color.lerp(hero, other.hero, t)!,
      blush: Color.lerp(blush, other.blush, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      lavender: Color.lerp(lavender, other.lavender, t)!,
      peach: Color.lerp(peach, other.peach, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      notice: Color.lerp(notice, other.notice, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      line: Color.lerp(line, other.line, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
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
  static ThemeData lightTheme = _buildTheme(AppPalette.light, Brightness.light);
  static ThemeData darkTheme = _buildTheme(AppPalette.dark, Brightness.dark);

  static ThemeData _buildTheme(AppPalette palette, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      fontFamily: 'Roboto',
      extensions: <ThemeExtension<dynamic>>[palette],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.softPink,
        brightness: brightness,
        primary: palette.primary,
        secondary: palette.accent,
        surface: palette.card,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: palette.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.card,
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textMuted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: palette.textPrimary,
          fontSize: 30,
          fontWeight: FontWeight.w800,
          height: 1.22,
          letterSpacing: -0.6,
        ),
        headlineMedium: TextStyle(
          color: palette.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.3,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          color: palette.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          height: 1.32,
          letterSpacing: -0.2,
        ),
        titleMedium: TextStyle(
          color: palette.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          height: 1.35,
        ),
        bodyLarge: TextStyle(
          color: palette.textSecondary,
          fontSize: 16,
          height: 1.58,
        ),
        bodyMedium: TextStyle(
          color: palette.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: palette.textMuted,
          fontSize: 12,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          color: palette.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        labelMedium: TextStyle(
          color: palette.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: isDark ? AppColors.textDark : AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.card,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: palette.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: palette.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: palette.primary, width: 1.4),
        ),
      ),
    );
  }
}
