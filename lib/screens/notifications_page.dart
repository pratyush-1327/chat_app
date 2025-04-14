import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Message Notifications",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text(
              'Private chats',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                value = false;
              },
            ),
          ),
          ListTile(
            title: Text(
              'Group chats',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                value = true;
              },
            ),
          ),
          ListTile(
            title: Text(
              'Do Not Disturb',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                value = true;
              },
            ),
          ),
        ],
      ),
    );
  }
}
