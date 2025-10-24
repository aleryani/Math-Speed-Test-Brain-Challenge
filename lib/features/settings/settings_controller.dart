import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/sound_service.dart';
import '../../core/services/storage_service.dart';
import '../game/models.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

class SettingsState {
  const SettingsState({
    required this.soundOn,
    required this.themeMode,
    required this.locale,
    required this.lastDifficulty,
    required this.lastTimerSeconds,
    required this.bestScore,
  });

  final bool soundOn;
  final ThemeMode themeMode;
  final Locale? locale;
  final Difficulty lastDifficulty;
  final int lastTimerSeconds;
  final int bestScore;

  SettingsState copyWith({
    bool? soundOn,
    ThemeMode? themeMode,
    Locale? locale,
    Difficulty? lastDifficulty,
    int? lastTimerSeconds,
    int? bestScore,
  }) {
    return SettingsState(
      soundOn: soundOn ?? this.soundOn,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      lastDifficulty: lastDifficulty ?? this.lastDifficulty,
      lastTimerSeconds: lastTimerSeconds ?? this.lastTimerSeconds,
      bestScore: bestScore ?? this.bestScore,
    );
  }
}

class SettingsController extends Notifier<SettingsState> {
  SettingsController();

  late final StorageService _storage;
  late final SoundService _soundService;

  @override
  SettingsState build() {
    _storage = ref.read(storageServiceProvider);
    _soundService = ref.read(soundServiceProvider);

    final soundOn = _storage.getSoundOn();
    final themeMode = _themeFromOption(_storage.getThemeMode());
    final languageCode = _storage.getLanguageCode();
    final locale = languageCode.isEmpty ? null : Locale(languageCode);
    final lastDifficulty = _storage.getLastDifficulty();
    final timer = _storage.getLastTimerSeconds();
    final best = _storage.getBestScore();
    _soundService.updateEnabled(soundOn);
    return SettingsState(
      soundOn: soundOn,
      themeMode: themeMode,
      locale: locale,
      lastDifficulty: lastDifficulty,
      lastTimerSeconds: timer,
      bestScore: best,
    );
  }

  ThemeMode _themeFromOption(String value) {
    final option = ThemeModeOption.values.firstWhere(
      (element) => element.name == value,
      orElse: () => ThemeModeOption.system,
    );
    switch (option) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }

  ThemeModeOption _themeOptionFromMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return ThemeModeOption.light;
      case ThemeMode.dark:
        return ThemeModeOption.dark;
      case ThemeMode.system:
        return ThemeModeOption.system;
    }
  }

  Future<void> toggleSound(bool value) async {
    state = state.copyWith(soundOn: value);
    _soundService.updateEnabled(value);
    await _storage.setSoundOn(value);
  }

  Future<void> updateTheme(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _storage.setThemeMode(_themeOptionFromMode(mode));
  }

  Future<void> updateLanguage(Locale? locale) async {
    state = state.copyWith(locale: locale);
    await _storage.setLanguageCode(locale?.languageCode ?? '');
  }

  Future<void> updateDifficulty(Difficulty difficulty) async {
    state = state.copyWith(lastDifficulty: difficulty);
    await _storage.setLastDifficulty(difficulty);
  }

  Future<void> updateTimer(int seconds) async {
    state = state.copyWith(lastTimerSeconds: seconds);
    await _storage.setLastTimerSeconds(seconds);
  }

  Future<void> updateBestScore(int score) async {
    if (score <= state.bestScore) {
      return;
    }
    state = state.copyWith(bestScore: score);
    await _storage.setBestScore(score);
  }

  Future<void> resetBestScore() async {
    await _storage.reset();
    state = state.copyWith(bestScore: 0);
  }
}
