import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class FoodTheme {
  FoodTheme._();

  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: FoodColors.primary,
        onPrimary: Colors.white,
        secondary: FoodColors.secondary,
        onSecondary: Colors.white,
        tertiary: FoodColors.accent,
        onTertiary: Colors.white,
        error: FoodColors.error,
        onError: Colors.white,
        surface: FoodColors.surface,
        onSurface: FoodColors.textPrimary,
        surfaceContainerHighest: FoodColors.background,
      );

  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: FoodColors.primary,
        onPrimary: Colors.white,
        secondary: FoodColors.secondary,
        onSecondary: Colors.white,
        tertiary: FoodColors.accent,
        onTertiary: Colors.white,
        error: FoodColors.error,
        onError: Colors.white,
        surface: FoodColors.darkSurface,
        onSurface: FoodColors.darkTextPrimary,
        surfaceContainerHighest: FoodColors.darkBackground,
      );

  static TextTheme get textTheme => GoogleFonts.nunitoTextTheme();
}
