import 'package:bitirme_mobile/core/constants/preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tema modu (sistem / açık / koyu) — SharedPreferences ile kalıcı.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static ThemeMode _boot = ThemeMode.system;

  /// [AppInitializers.init] içinde [runApp] öncesi çağrılmalıdır.
  static Future<void> preloadFromDisk() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _boot = _fromStorage(prefs.getString(PreferenceKeys.themeMode));
  }

  static ThemeMode _fromStorage(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  static String _toStorage(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  @override
  ThemeMode build() {
    return _boot;
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    _boot = mode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.themeMode, _toStorage(mode));
  }
}

final NotifierProvider<ThemeModeNotifier, ThemeMode> themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
