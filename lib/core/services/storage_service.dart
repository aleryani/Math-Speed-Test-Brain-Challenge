import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/game/models.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden');
});

class StorageKeys {
  static const bestScore = 'prefs.bestScore';
  static const soundOn = 'prefs.soundOn';
  static const themeMode = 'prefs.themeMode';
  static const language = 'prefs.language';
  static const lastDifficulty = 'prefs.lastDifficulty';
  static const lastTimerSecs = 'prefs.lastTimerSecs';
  static const dailyCompleted = 'prefs.daily.completed';
}

class StorageService {
  StorageService._(this._prefs);

  factory StorageService.fromPrefs(SharedPreferences prefs) {
    return StorageService._(prefs);
  }

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  int getBestScore() => _prefs.getInt(StorageKeys.bestScore) ?? 0;

  Future<void> setBestScore(int score) =>
      _prefs.setInt(StorageKeys.bestScore, score);

  bool getSoundOn() => _prefs.getBool(StorageKeys.soundOn) ?? true;

  Future<void> setSoundOn(bool value) =>
      _prefs.setBool(StorageKeys.soundOn, value);

  String getThemeMode() =>
      _prefs.getString(StorageKeys.themeMode) ?? ThemeModeOption.system.name;

  Future<void> setThemeMode(ThemeModeOption mode) =>
      _prefs.setString(StorageKeys.themeMode, mode.name);

  String getLanguageCode() => _prefs.getString(StorageKeys.language) ?? '';

  Future<void> setLanguageCode(String code) =>
      _prefs.setString(StorageKeys.language, code);

  Difficulty getLastDifficulty() {
    final stored = _prefs.getString(StorageKeys.lastDifficulty);
    return Difficulty.values.firstWhere(
      (d) => d.name == stored,
      orElse: () => Difficulty.easy,
    );
  }

  Future<void> setLastDifficulty(Difficulty difficulty) =>
      _prefs.setString(StorageKeys.lastDifficulty, difficulty.name);

  int getLastTimerSeconds() =>
      _prefs.getInt(StorageKeys.lastTimerSecs) ?? 30;

  Future<void> setLastTimerSeconds(int seconds) =>
      _prefs.setInt(StorageKeys.lastTimerSecs, seconds);

  Future<void> reset() async {
    await _prefs.remove(StorageKeys.bestScore);
  }

  String? getDailyCompletedKey() => _prefs.getString(StorageKeys.dailyCompleted);

  Future<void> setDailyCompletedKey(String key) async {
    await _prefs.setString(StorageKeys.dailyCompleted, key);
  }
}

enum ThemeModeOption { system, light, dark }
