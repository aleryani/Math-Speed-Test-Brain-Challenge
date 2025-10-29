import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final notifier = ref.read(settingsControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile.adaptive(
            title: Text(l10n.sound),
            value: settings.soundOn,
            onChanged: (value) => notifier.toggleSound(value),
          ),
          const SizedBox(height: 16),
          Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeSystem),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (mode) => notifier.updateTheme(mode ?? ThemeMode.system),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeLight),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (mode) => notifier.updateTheme(mode ?? ThemeMode.light),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.themeDark),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (mode) => notifier.updateTheme(mode ?? ThemeMode.dark),
          ),
          const SizedBox(height: 16),
          Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          RadioListTile<Locale?>(
            title: const Text('English'),
            value: const Locale('en'),
            groupValue: settings.locale,
            onChanged: (locale) => notifier.updateLanguage(locale),
          ),
          RadioListTile<Locale?>(
            title: const Text('العربية'),
            value: const Locale('ar'),
            groupValue: settings.locale,
            onChanged: (locale) => notifier.updateLanguage(locale),
          ),
          RadioListTile<Locale?>(
            title: Text(l10n.themeSystem),
            value: null,
            groupValue: settings.locale,
            onChanged: (locale) => notifier.updateLanguage(locale),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(l10n.resetBestScore),
            trailing: const Icon(Icons.restart_alt),
            onTap: () => _confirmReset(context, notifier, l10n),
          ),
          ListTile(
            title: Text(l10n.about),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.appTitle,
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmReset(
    BuildContext context,
    SettingsController notifier,
    AppLocalizations l10n,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetBestScore),
        content: Text(l10n.confirmReset),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await notifier.resetBestScore();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
