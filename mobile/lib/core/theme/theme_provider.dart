import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

enum AppCategory { food, clothing }

final activeCategoryProvider = StateProvider<AppCategory>(
  (ref) => AppCategory.food,
);

final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.system,
);

final lightThemeProvider = Provider<ThemeData>((ref) {
  final category = ref.watch(activeCategoryProvider);
  return switch (category) {
    AppCategory.food => AppTheme.foodLight(),
    AppCategory.clothing => AppTheme.clothingLight(),
  };
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final category = ref.watch(activeCategoryProvider);
  return switch (category) {
    AppCategory.food => AppTheme.foodDark(),
    AppCategory.clothing => AppTheme.clothingDark(),
  };
});
