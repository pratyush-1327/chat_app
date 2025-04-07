import 'package:flutter/material.dart';

class ContactProfileScreen extends StatelessWidget {
  const ContactProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String contactName = "Cindy";
    const String contactPhone = "+14844533842";
    const String contactImageUrl =
        "https://via.placeholder.com/150"; // Placeholder image

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(contactImageUrl),
              ),
              const SizedBox(height: 15),
              Text(
                contactName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 5),
              Text(
                contactPhone,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Acttionbutton(context, Icons.message, "Message", () {}),
                  _Acttionbutton(context, Icons.call, "Call", () {}),
                  _Acttionbutton(
                      context, Icons.notifications_off, "Mute", () {}),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "More actions",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Divider(height: 20),
              _buildMoreActionTile(context, Icons.image, "View media", () {}),
              _buildMoreActionTile(
                  context, Icons.search, "Search in conversation", () {}),
              _buildMoreActionTile(
                  context, Icons.notifications, "Notifications", () {}),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Acttionbutton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: IconButton(
            icon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: onTap,
            tooltip: label,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildMoreActionTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.inverseSurface),
      title: Text(title),
      onTap: onTap,
    );
  }
}
