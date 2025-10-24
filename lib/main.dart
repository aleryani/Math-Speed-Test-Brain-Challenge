import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/sound_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/ads_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.create();
  final soundService = SoundService();
  final adsService = AdsService();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        soundServiceProvider.overrideWithValue(soundService),
        adsServiceProvider.overrideWithValue(adsService),
      ],
      child: const AppBootstrap(),
    ),
  );
}

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const App();
  }
}
