import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/ads_service.dart';
import '../../core/services/sound_service.dart';
import '../../core/services/storage_service.dart';
import '../settings/settings_controller.dart';
import 'models.dart';
import 'question_generator.dart';

final gameControllerProvider =
    AutoDisposeNotifierProvider<GameController, GameState>(GameController.new);

class GameController extends AutoDisposeNotifier<GameState> {
  GameController();

  Timer? _timer;
  late SoundService _soundService;
  late StorageService _storage;
  late SettingsController _settings;
  QuestionGenerator? _generator;
  List<Question>? _preset;
  int _questionIndex = 0;

  @override
  GameState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    _soundService = ref.read(soundServiceProvider);
    _storage = ref.read(storageServiceProvider);
    _settings = ref.read(settingsControllerProvider.notifier);
    return GameState.initial().copyWith(bestScore: ref.read(settingsControllerProvider).bestScore);
  }

  void start(GameConfig config, {List<Question>? presetQuestions}) {
    _timer?.cancel();
    _preset = presetQuestions;
    _questionIndex = 0;
    _generator = QuestionGenerator(
      seed: config.seed,
      difficulty: config.difficulty,
    );
    state = GameState.initial().copyWith(
      config: config,
      timeLeft: config.durationSeconds,
      isActive: true,
      bestScore: ref.read(settingsControllerProvider).bestScore,
      score: 0,
      streak: 0,
      questionsAnswered: 0,
      showCorrectFeedback: false,
      showWrongFeedback: false,
      isNewBest: false,
    );
    _nextQuestion();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void tick() {
    if (!state.isActive) {
      return;
    }
    final remaining = state.timeLeft - 1;
    if (remaining <= 0) {
      endRound();
    } else {
      state = state.copyWith(timeLeft: remaining);
    }
  }

  Future<void> submitAnswer(int value) async {
    if (!state.isActive || state.currentQuestion == null) {
      return;
    }
    final config = state.config;
    if (config == null) {
      return;
    }
    final isCorrect = value == state.currentQuestion!.answer;
    final newQuestionsAnswered = state.questionsAnswered + 1;
    int score = state.score;
    int streak = state.streak;
    bool showCorrect = false;
    bool showWrong = false;
    if (isCorrect) {
      streak += 1;
      var delta = 10;
      if (streak % 3 == 0) {
        delta += 2;
      }
      score += delta;
      showCorrect = true;
      HapticFeedback.lightImpact();
      if (config.soundOn) {
        await _soundService.playCorrect();
      }
    } else {
      streak = 0;
      score -= 5;
      if (score < 0) {
        score = 0;
      }
      showWrong = true;
      HapticFeedback.mediumImpact();
      if (config.soundOn) {
        await _soundService.playWrong();
      }
    }
    state = state.copyWith(
      score: score,
      streak: streak,
      questionsAnswered: newQuestionsAnswered,
      showCorrectFeedback: showCorrect,
      showWrongFeedback: showWrong,
    );

    final totalQuestions = config.totalQuestions;
    if (totalQuestions != null && newQuestionsAnswered >= totalQuestions) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      endRound();
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _nextQuestion();
  }

  void _nextQuestion() {
    final config = state.config;
    if (config == null) {
      return;
    }
    Question question;
    if (_preset != null && _questionIndex < _preset!.length) {
      question = _preset![_questionIndex];
      _questionIndex++;
    } else {
      question = (_generator ?? QuestionGenerator()).nextQuestion(config.difficulty);
    }
    state = state.copyWith(
      currentQuestion: question,
      showCorrectFeedback: false,
      showWrongFeedback: false,
    );
  }

  void endRound() {
    if (!state.isActive) {
      return;
    }
    _timer?.cancel();
    final finalScore = state.score;
    final best = state.bestScore;
    bool isNewBest = false;
    if (finalScore > best) {
      isNewBest = true;
      _settings.updateBestScore(finalScore);
    }
    final config = state.config;
    if (config != null && config.isDaily && config.seed != null) {
      _storage.setDailyCompletedKey(config.seed.toString());
    }
    state = state.copyWith(
      isActive: false,
      timeLeft: 0,
      showCorrectFeedback: false,
      showWrongFeedback: false,
      isNewBest: isNewBest,
      bestScore: isNewBest ? finalScore : best,
      clearQuestion: true,
    );
    ref.read(adsServiceProvider).loadInterstitialIfNeeded();
  }
}
