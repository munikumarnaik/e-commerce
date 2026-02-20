import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../theme/theme_provider.dart';

class LocalStorageService {
  static const _prefsBox = 'preferences';

  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _activeCategoryKey = 'active_category';
  static const _themeModeKey = 'theme_mode';

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_prefsBox);
  }

  // Onboarding
  bool get isOnboardingComplete => _box.get(_onboardingCompleteKey, defaultValue: false);

  Future<void> setOnboardingComplete() =>
      _box.put(_onboardingCompleteKey, true);

  // Active Category
  AppCategory get activeCategory {
    final value = _box.get(_activeCategoryKey, defaultValue: 'food');
    return value == 'clothing' ? AppCategory.clothing : AppCategory.food;
  }

  Future<void> setActiveCategory(AppCategory category) =>
      _box.put(_activeCategoryKey, category == AppCategory.clothing ? 'clothing' : 'food');

  // Theme Mode
  ThemeMode get themeMode {
    final value = _box.get(_themeModeKey, defaultValue: 'system');
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _box.put(_themeModeKey, value);
  }
}
