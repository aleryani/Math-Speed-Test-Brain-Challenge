import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/ads_service.dart';
import '../../theme/app_theme.dart';
import '../game/game_screen.dart';
import '../game/models.dart';

class ResultsScreenArgs {
  const ResultsScreenArgs({
    required this.score,
    required this.bestScore,
    required this.isNewBest,
    required this.config,
  });

  final int score;
  final int bestScore;
  final bool isNewBest;
  final GameConfig config;
}

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  static const routeName = '/results';

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  late ResultsScreenArgs _args;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is ResultsScreenArgs) {
      _args = arguments;
      _initialized = true;
      final ads = ref.read(adsServiceProvider);
      if (ads.isEnabled) {
        ads.showInterstitial();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.resultsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final theme = Theme.of(context);
    final feedback = theme.extension<FeedbackColors>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Icon(
              Icons.bolt,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.score,
              style: theme.textTheme.titleMedium,
            ),
            Text(
              _args.score.toString(),
              style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.bestScore(_args.bestScore.toString()),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_args.isNewBest)
              Chip(
                label: Text(l10n.newBestScore),
                backgroundColor: feedback?.success.withOpacity(0.15),
              ),
            const Spacer(),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      GameScreen.routeName,
                      arguments: GameScreenArgs(config: _args.config),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.playAgain),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final message = l10n.shareScoreMessage(_args.score.toString());
                    final uri = Uri.parse('sms:?body=${Uri.encodeComponent(message)}');
                    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                      final mailUri = Uri(
                        scheme: 'mailto',
                        queryParameters: {'subject': l10n.appTitle, 'body': message},
                      );
                      await launchUrl(mailUri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: Text(l10n.share),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home_filled),
                  label: Text(l10n.home),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
