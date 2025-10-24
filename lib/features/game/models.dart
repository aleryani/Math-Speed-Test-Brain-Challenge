import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

extension DifficultyLabels on Difficulty {
  String localized(BuildContext context, {String? fallback}) {
    switch (this) {
      case Difficulty.easy:
        return fallback ?? 'Easy';
      case Difficulty.medium:
        return fallback ?? 'Medium';
      case Difficulty.hard:
        return fallback ?? 'Hard';
    }
  }
}

class GameConfig {
  const GameConfig({
    required this.difficulty,
    required this.durationSeconds,
    required this.soundOn,
    this.isDaily = false,
    this.totalQuestions,
    this.seed,
  });

  final Difficulty difficulty;
  final int durationSeconds;
  final bool soundOn;
  final bool isDaily;
  final int? totalQuestions;
  final int? seed;
}

class Question {
  const Question({
    required this.a,
    required this.b,
    required this.operator,
    required this.answer,
    required this.options,
  });

  final int a;
  final int b;
  final String operator;
  final int answer;
  final List<int> options;

  String get text => '$a $operator $b = ?';
}

class GameState {
  const GameState({
    required this.config,
    required this.score,
    required this.timeLeft,
    required this.streak,
    required this.isActive,
    required this.currentQuestion,
    required this.questionsAnswered,
    required this.bestScore,
    required this.isNewBest,
    required this.showCorrectFeedback,
    required this.showWrongFeedback,
  });

  final GameConfig? config;
  final int score;
  final int timeLeft;
  final int streak;
  final bool isActive;
  final Question? currentQuestion;
  final int questionsAnswered;
  final int bestScore;
  final bool isNewBest;
  final bool showCorrectFeedback;
  final bool showWrongFeedback;

  bool get isFinished => !isActive && currentQuestion == null;

  GameState copyWith({
    GameConfig? config,
    int? score,
    int? timeLeft,
    int? streak,
    bool? isActive,
    Question? currentQuestion,
    int? questionsAnswered,
    int? bestScore,
    bool? isNewBest,
    bool? showCorrectFeedback,
    bool? showWrongFeedback,
    bool clearQuestion = false,
  }) {
    return GameState(
      config: config ?? this.config,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      streak: streak ?? this.streak,
      isActive: isActive ?? this.isActive,
      currentQuestion: clearQuestion ? null : currentQuestion ?? this.currentQuestion,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      bestScore: bestScore ?? this.bestScore,
      isNewBest: isNewBest ?? this.isNewBest,
      showCorrectFeedback: showCorrectFeedback ?? this.showCorrectFeedback,
      showWrongFeedback: showWrongFeedback ?? this.showWrongFeedback,
    );
  }

  factory GameState.initial() {
    return const GameState(
      config: null,
      score: 0,
      timeLeft: 0,
      streak: 0,
      isActive: false,
      currentQuestion: null,
      questionsAnswered: 0,
      bestScore: 0,
      isNewBest: false,
      showCorrectFeedback: false,
      showWrongFeedback: false,
    );
  }
}
