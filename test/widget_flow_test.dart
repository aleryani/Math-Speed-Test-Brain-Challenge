import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:math_speed_test_brain_challenge/app.dart';
import 'package:math_speed_test_brain_challenge/core/services/sound_service.dart';
import 'package:math_speed_test_brain_challenge/core/services/storage_service.dart';
import 'package:math_speed_test_brain_challenge/features/game/game_controller.dart';
import 'package:math_speed_test_brain_challenge/features/game/game_screen.dart';
import 'package:math_speed_test_brain_challenge/features/home/home_screen.dart';
import 'package:math_speed_test_brain_challenge/features/results/results_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home to Game to Results navigation works', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService.fromPrefs(prefs);
    final sound = SoundService(enablePlayer: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          soundServiceProvider.overrideWithValue(sound),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(GameScreen)),
    );
    container.read(gameControllerProvider.notifier).endRound();
    await tester.pumpAndSettle();

    expect(find.byType(ResultsScreen), findsOneWidget);
  });

  testWidgets('Arabic locale uses RTL directionality', (tester) async {
    SharedPreferences.setMockInitialValues({StorageKeys.language: 'ar'});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService.fromPrefs(prefs);
    final sound = SoundService(enablePlayer: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          soundServiceProvider.overrideWithValue(sound),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    final directionality = tester.widget<Directionality>(find.byType(Directionality).first);
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
