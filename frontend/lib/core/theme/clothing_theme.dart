import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ClothingTheme {
  ClothingTheme._();

  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: ClothingColors.primary,
        onPrimary: Colors.white,
        secondary: ClothingColors.secondary,
        onSecondary: Colors.white,
        tertiary: ClothingColors.accent,
        onTertiary: Colors.white,
        error: ClothingColors.error,
        onError: Colors.white,
        surface: ClothingColors.surface,
        onSurface: ClothingColors.textPrimary,
        surfaceContainerHighest: ClothingColors.background,
      );

  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: ClothingColors.accent,
        onPrimary: Colors.white,
        secondary: ClothingColors.secondary,
        onSecondary: Colors.white,
        tertiary: ClothingColors.gold,
        onTertiary: Colors.black,
        error: ClothingColors.error,
        onError: Colors.white,
        surface: ClothingColors.darkSurface,
        onSurface: ClothingColors.darkTextPrimary,
        surfaceContainerHighest: ClothingColors.darkBackground,
      );

  static TextTheme get textTheme => GoogleFonts.poppinsTextTheme();
}
