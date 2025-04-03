import 'package:FlutChat/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppearancePage extends ConsumerWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_6), // Icon for theme
              title: const Text('Theme'),
              subtitle: Text(_themeModeToString(themeMode)),
              onTap: () {
                _showThemeDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.read(themeModeProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('System'),
                value: ThemeMode.system,
                groupValue: currentThemeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).state = value;
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: currentThemeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).state = value;
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: currentThemeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).state = value;
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
