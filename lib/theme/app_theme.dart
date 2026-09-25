import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens pulled straight from the Figma "Colors" frame.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF7C3AED); // Primary
  static const accent = Color(0xFF8B5CF6); // Accent
  static const surface = Color(0xFFF5F3FF); // Surface
  static const textDark = Color(0xFF111827); // Text

  // Secondary tones seen throughout the screens.
  static const bodyText = Color(0xFF403E43);
  static const placeholder = Color(0xFF909298);
  static const bgLogin = Color(0xFFF6F5FA);
  static const bgApp = Color(0xFFFBFAFE);
  static const border = Color(0x80B8BAC0); // rgba(184,186,191,0.5)
  static const success = Color(0xFF16A34A);
  static const danger = Color(0xFFDC2626);
  static const pillLavender = Color(0xFFB797ED);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.bgApp,
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(47),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
