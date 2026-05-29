import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/providers.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = _prefs.getBool('isDarkMode') ?? true;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
    state = newMode;
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _prefs.setBool('isDarkMode', mode == ThemeMode.dark);
    state = mode;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs) : super(const Locale('en')) {
    _loadLocale();
  }

  void _loadLocale() {
    final code = _prefs.getString('locale') ?? 'en';
    state = Locale(code);
  }

  Future<void> setLocale(String languageCode) async {
    await _prefs.setString('locale', languageCode);
    state = Locale(languageCode);
  }
}
