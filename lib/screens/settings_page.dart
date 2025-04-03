import 'package:FlutChat/features/auth/presentation/login_screen.dart';
import 'package:FlutChat/features/auth/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'appearance_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

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
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(''), // Placeholder image
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email?.split('@')[0] ?? 'Daniel',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user?.email ?? '+14844578842',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                TextButton(
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
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.remove_red_eye),
              title: const Text('Appearance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AppearancePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Privacy'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Storage & Data'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
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
