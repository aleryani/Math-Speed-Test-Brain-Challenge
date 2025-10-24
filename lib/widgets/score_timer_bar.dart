import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ScoreTimerBar extends StatelessWidget {
  const ScoreTimerBar({
    super.key,
    required this.score,
    required this.timeLeft,
    required this.scoreLabel,
    required this.timeLabel,
  });

  final int score;
  final int timeLeft;
  final String scoreLabel;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<SurfaceGradients>();
    final highlight = gradients?.cardHighlight ??
        [
          theme.colorScheme.primaryContainer.withOpacity(0.8),
          theme.colorScheme.tertiary.withOpacity(0.7),
        ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: highlight,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _InfoTile(label: scoreLabel, value: score.toString()),
          _InfoTile(label: timeLabel, value: timeLeft.toString()),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onPrimary.withOpacity(0.9),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
