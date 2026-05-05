import 'package:flutter/material.dart';

/// Claude-inspired color scheme and theme.
/// Uses Claude's signature warm beige, tan, and terracotta/sienna accents.
class ClaudeTheme {
  ClaudeTheme._();

  // ── Core Claude palette ──────────────────────────────────────────────
  static const Color _claudeOrange = Color(0xFFDA7756); // primary accent
  static const Color _claudeSienna = Color(0xFFC4644A); // deeper accent
  static const Color _claudeCream = Color(0xFFFAF6F1);  // background
  static const Color _claudeBeige = Color(0xFFF3EDE7);  // surface / cards
  static const Color _claudeTan = Color(0xFFE8DED4);    // border / divider
  static const Color _claudeBrown = Color(0xFF6B5B4E);  // body text
  static const Color _claudeDarkBrown = Color(0xFF3D3229); // headline text
  static const Color _claudeWhite = Color(0xFFFFFFFF);

  // Dark mode palette
  static const Color _claudeDarkBg = Color(0xFF1A1612);
  static const Color _claudeDarkSurface = Color(0xFF2A2420);
  static const Color _claudeDarkCard = Color(0xFF342D28);
  static const Color _claudeDarkText = Color(0xFFE8DED4);
  static const Color _claudeDarkSubtext = Color(0xFFB0A498);

  // ── Light Theme ──────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _claudeOrange,
      onPrimary: _claudeWhite,
      primaryContainer: const Color(0xFFFFDDD2),
      onPrimaryContainer: _claudeSienna,
      secondary: _claudeBrown,
      onSecondary: _claudeWhite,
      secondaryContainer: _claudeTan,
      onSecondaryContainer: _claudeDarkBrown,
      surface: _claudeBeige,
      onSurface: _claudeDarkBrown,
      error: const Color(0xFFBA1A1A),
      onError: _claudeWhite,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      outline: _claudeTan,
      outlineVariant: const Color(0xFFD5C9BE),
      shadow: Colors.black26,
      inverseSurface: _claudeDarkBrown,
      onInverseSurface: _claudeCream,
      inversePrimary: const Color(0xFFFFB59C),
      surfaceContainerHighest: const Color(0xFFEDE5DC),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _claudeCream,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: _claudeBeige,
        foregroundColor: _claudeDarkBrown,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: _claudeOrange.withAlpha(30),
        titleTextStyle: const TextStyle(
          color: _claudeDarkBrown,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: _claudeOrange,
        unselectedLabelColor: _claudeBrown.withAlpha(180),
        indicatorColor: _claudeOrange,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: _claudeTan,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: _claudeWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: _claudeBrown.withAlpha(25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _claudeTan.withAlpha(150)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _claudeBeige,
          foregroundColor: _claudeDarkBrown,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _claudeOrange,
          foregroundColor: _claudeWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _claudeOrange,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _claudeWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(color: _claudeTan, thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: _claudeTan,
        color: _claudeOrange,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _claudeWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _claudeTan),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _claudeTan),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _claudeOrange, width: 2),
        ),
      ),
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFFFB59C),
      onPrimary: const Color(0xFF5C1900),
      primaryContainer: _claudeSienna,
      onPrimaryContainer: const Color(0xFFFFDDD2),
      secondary: _claudeDarkSubtext,
      onSecondary: _claudeDarkBg,
      secondaryContainer: const Color(0xFF4A3F36),
      onSecondaryContainer: _claudeDarkText,
      surface: _claudeDarkSurface,
      onSurface: _claudeDarkText,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      outline: const Color(0xFF5A4E44),
      outlineVariant: const Color(0xFF4A3F36),
      shadow: Colors.black54,
      inverseSurface: _claudeDarkText,
      onInverseSurface: _claudeDarkBg,
      inversePrimary: _claudeOrange,
      surfaceContainerHighest: _claudeDarkCard,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _claudeDarkBg,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: _claudeDarkSurface,
        foregroundColor: _claudeDarkText,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: _claudeOrange.withAlpha(20),
        titleTextStyle: TextStyle(
          color: _claudeDarkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: const Color(0xFFFFB59C),
        unselectedLabelColor: _claudeDarkSubtext,
        indicatorColor: const Color(0xFFFFB59C),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: const Color(0xFF4A3F36),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: _claudeDarkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF4A3F36)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _claudeDarkCard,
          foregroundColor: _claudeDarkText,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _claudeOrange,
          foregroundColor: _claudeWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFFB59C),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _claudeDarkCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(color: const Color(0xFF4A3F36), thickness: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: const Color(0xFF4A3F36),
        color: const Color(0xFFFFB59C),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _claudeDarkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF4A3F36)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF4A3F36)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _claudeOrange, width: 2),
        ),
      ),
    );
  }
}
