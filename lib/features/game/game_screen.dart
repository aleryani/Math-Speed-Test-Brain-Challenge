import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/app_theme.dart';
import '../../widgets/feedback_overlay.dart';
import '../../widgets/score_timer_bar.dart';
import '../../widgets/big_button.dart';
import '../results/results_screen.dart';
import 'game_controller.dart';
import 'models.dart';

class GameScreenArgs {
  const GameScreenArgs({
    required this.config,
    this.presetQuestions,
  });

  final GameConfig config;
  final List<Question>? presetQuestions;
}

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  static const routeName = '/game';

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _initialized = false;
  ProviderSubscription<GameState>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ref.listen<GameState>(
      gameControllerProvider,
      (previous, next) {
        if (previous != null && previous.isActive && next.isFinished) {
          final score = previous.score;
          final best = next.bestScore;
          final isNewBest = next.isNewBest;
          if (!mounted) {
            return;
          }
          Navigator.of(context).pushReplacementNamed(
            ResultsScreen.routeName,
            arguments: ResultsScreenArgs(
              score: score,
              bestScore: best,
              isNewBest: isNewBest,
              config: previous.config!,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is GameScreenArgs) {
      ref.read(gameControllerProvider.notifier).start(
            arguments.config,
            presetQuestions: arguments.presetQuestions,
          );
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    if (!_initialized || state.config == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.loading)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);
    final feedback = theme.extension<FeedbackColors>()!;
    final question = state.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homePlay),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScoreTimerBar(
                  score: state.score,
                  timeLeft: state.timeLeft,
                  scoreLabel: l10n.score,
                  timeLabel: l10n.timer,
                ),
                const SizedBox(height: 12),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 1,
                    end: state.config!.durationSeconds == 0
                        ? 0
                        : state.timeLeft / state.config!.durationSeconds,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: value.clamp(0.0, 1.0),
                        minHeight: 8,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Center(
                            key: ValueKey(question?.text ?? 'loading'),
                            child: Text(
                              question?.text ?? '',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (question != null)
                        _AnswerGrid(
                          question: question,
                          onTap: (value) => controller.submitAnswer(value),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FeedbackOverlay(
            showCorrect: state.showCorrectFeedback,
            showWrong: state.showWrongFeedback,
            successColor: feedback.success,
            errorColor: feedback.error,
          ),
        ],
      ),
    );
  }
}

class _AnswerGrid extends StatelessWidget {
  const _AnswerGrid({
    required this.question,
    required this.onTap,
  });

  final Question question;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final buttonWidth = (maxWidth - 24) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: question.options
              .map(
                (option) => SizedBox(
                  width: buttonWidth,
                  child: BigButton(
                    label: option.toString(),
                    onTap: () => onTap(option),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
