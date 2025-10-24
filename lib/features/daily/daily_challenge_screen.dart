import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/services/storage_service.dart';
import '../../core/utils/date_seed.dart';
import '../game/game_screen.dart';
import '../game/models.dart';
import '../game/question_generator.dart';
import '../settings/settings_controller.dart';

class DailyChallengeScreen extends ConsumerWidget {
  const DailyChallengeScreen({super.key});

  static const routeName = '/daily';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final storage = ref.watch(storageServiceProvider);
    final settings = ref.watch(settingsControllerProvider);
    final today = DateTime.now();
    final seed = dateSeed(today);
    final generator = QuestionGenerator(seed: seed, difficulty: Difficulty.hard);
    final questions = List<Question>.generate(
      10,
      (_) => generator.nextQuestion(Difficulty.hard),
    );
    final completedKey = storage.getDailyCompletedKey();
    final isCompleted = completedKey == seed.toString();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dailyChallenge)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dailyDescription,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (isCompleted)
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(l10n.dailyCompleted),
                        ],
                      )
                    else
                      Text(l10n.homePlay),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: questions
                          .take(3)
                          .map((q) => Chip(label: Text(q.text.replaceAll('= ?', ''))))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final config = GameConfig(
                  difficulty: Difficulty.hard,
                  durationSeconds: 60,
                  soundOn: settings.soundOn,
                  isDaily: true,
                  totalQuestions: questions.length,
                  seed: seed,
                );
                Navigator.of(context).pushReplacementNamed(
                  GameScreen.routeName,
                  arguments: GameScreenArgs(
                    config: config,
                    presetQuestions: questions,
                  ),
                );
              },
              child: Text(l10n.start),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
