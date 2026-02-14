import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.sage,
        secondary: AppColors.teal,
        surface: AppColors.lightBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightText,
        error: AppColors.warning,
        onError: Colors.white,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBg,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightDivider,
      textTheme: _textTheme(base.textTheme, Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBg,
        foregroundColor: AppColors.lightText,
        elevation: 0,
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selectedColor: AppColors.sage,
        labelStyle: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkBg,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.sage, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.lexend(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.sage,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.sage,
        secondary: AppColors.teal,
        surface: AppColors.darkBg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkText,
        error: AppColors.warning,
        onError: Colors.white,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBg,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
      textTheme: _textTheme(base.textTheme, Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selectedColor: AppColors.sage,
        labelStyle: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.sage, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.lexend(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColors.sage,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final color = isDark ? AppColors.darkText : AppColors.lightText;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return base.copyWith(
      displayLarge: GoogleFonts.lexend(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineSmall: GoogleFonts.lexend(
        fontSize: 21,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: GoogleFonts.lexend(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: GoogleFonts.lexend(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: GoogleFonts.lexend(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelLarge: GoogleFonts.lexend(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      labelMedium: GoogleFonts.lexend(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
    );
  }
}
