import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/daily/daily_challenge_screen.dart';
import 'features/game/game_screen.dart';
import 'features/home/home_screen.dart';
import 'features/results/results_screen.dart';
import 'features/settings/settings_controller.dart';
import 'features/settings/settings_screen.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    return MaterialApp(
      title: 'Math Speed Test – Brain Challenge',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: settings.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        GameScreen.routeName: (_) => const GameScreen(),
        ResultsScreen.routeName: (_) => const ResultsScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        DailyChallengeScreen.routeName: (_) => const DailyChallengeScreen(),
      },
      initialRoute: HomeScreen.routeName,
    );
  }
}
