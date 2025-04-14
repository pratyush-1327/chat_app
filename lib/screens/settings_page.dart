import 'package:FlutChat/features/auth/presentation/login_screen.dart';
import 'package:FlutChat/features/auth/provider/auth_provider.dart';
import 'package:FlutChat/core/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/login_screen.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(appUser?.imageUrl ?? ''),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appUser?.name ?? 'Daniel',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        appUser?.email ?? '+14844578842',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Edit'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "General",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.notifications,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Notifications'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.remove_red_eye,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Appearance'),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).state =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Privacy'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.cloud,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Storage & Data'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('About'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
