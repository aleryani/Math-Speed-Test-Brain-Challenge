import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/big_button.dart';
import '../settings/settings_controller.dart';
import '../game/game_screen.dart';
import '../game/models.dart';
import '../settings/settings_screen.dart';
import '../daily/daily_challenge_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Text(
              l10n.homeQuickPlay,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            BigButton(
              label: l10n.homePlay,
              onTap: () {
                final config = GameConfig(
                  difficulty: settings.lastDifficulty,
                  durationSeconds: settings.lastTimerSeconds,
                  soundOn: settings.soundOn,
                );
                Navigator.of(context).pushNamed(
                  GameScreen.routeName,
                  arguments: GameScreenArgs(config: config),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.homeBestScore,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.highScore,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          settings.bestScore.toString(),
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.emoji_events, size: 48, color: theme.colorScheme.secondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _HomeActionButton(
                  icon: Icons.grid_view_rounded,
                  label: l10n.homeGameModes,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GameModesScreen()),
                    );
                  },
                ),
                _HomeActionButton(
                  icon: Icons.calendar_today_rounded,
                  label: l10n.homeDailyChallenge,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DailyChallengeScreen()),
                    );
                  },
                ),
                _HomeActionButton(
                  icon: Icons.emoji_events_outlined,
                  label: l10n.homeHighScore,
                  onTap: () {
                    _showHighScoreDialog(context, settings.bestScore, l10n);
                  },
                ),
                _HomeActionButton(
                  icon: Icons.settings_rounded,
                  label: l10n.homeSettings,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHighScoreDialog(BuildContext context, int bestScore, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.highScore),
          content: Text(l10n.bestScore(bestScore.toString())),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  const _HomeActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 150,
      height: 140,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameModesScreen extends ConsumerStatefulWidget {
  const GameModesScreen({super.key});

  @override
  ConsumerState<GameModesScreen> createState() => _GameModesScreenState();
}

class _GameModesScreenState extends ConsumerState<GameModesScreen> {
  late Difficulty _selectedDifficulty;
  late int _selectedTimer;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsControllerProvider);
    _selectedDifficulty = settings.lastDifficulty;
    _selectedTimer = settings.lastTimerSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final difficultyLabels = {
      Difficulty.easy: l10n.easy,
      Difficulty.medium: l10n.medium,
      Difficulty.hard: l10n.hard,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.gameModesTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.difficulty, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: Difficulty.values.map((difficulty) {
                final selected = difficulty == _selectedDifficulty;
                return ChoiceChip(
                  label: Text(difficultyLabels[difficulty]!),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => _selectedDifficulty = difficulty);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(l10n.timer, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [30, 60].map((seconds) {
                final selected = seconds == _selectedTimer;
                return ChoiceChip(
                  label: Text(l10n.seconds(seconds.toString())),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => _selectedTimer = seconds);
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final notifier = ref.read(settingsControllerProvider.notifier);
                await notifier.updateDifficulty(_selectedDifficulty);
                await notifier.updateTimer(_selectedTimer);
                final settings = ref.read(settingsControllerProvider);
                final config = GameConfig(
                  difficulty: settings.lastDifficulty,
                  durationSeconds: settings.lastTimerSeconds,
                  soundOn: settings.soundOn,
                );
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed(
                  GameScreen.routeName,
                  arguments: GameScreenArgs(config: config),
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
