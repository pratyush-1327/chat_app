import 'package:FlutChat/features/contacts/presentation/contact_profile_screen.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String _searchString = '';
  final SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 160,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                "Contacts",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            SearchAnchor.bar(
              barElevation: WidgetStatePropertyAll(0),
              viewHintText: "Search Contacts...",
              barHintText: "Search Contacts ...",
              searchController: searchController,
              onChanged: (String value) {
                setState(() {
                  _searchString = value;
                });
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return contacts
                    .where((element) => element.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .map<Widget>((contact) => ListTile(
                          title: Text(contact.name),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ContactProfileScreen()));
                          },
                        ))
                    .toList();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ContactProfileScreen()));
              },
              leading: const CircleAvatar(
                radius: 30,
                child: Icon(Icons.person),
              ),
              title: Text(contact.name),
            ),
          );
        },
      ),
    );
  }
}

class Contact {
  final String name;

  Contact({required this.name});
}

final List<Contact> contacts = [
  Contact(name: 'Alicia'),
  Contact(name: 'Anthony'),
  Contact(name: 'Ben'),
  Contact(name: 'Bryan'),
  Contact(name: 'Brianna'),
  Contact(name: 'Cindy'),
  Contact(name: 'Daisy'),
  Contact(name: 'Diana'),
  Contact(name: 'Edward'),
  Contact(name: 'Emily'),
  Contact(name: 'Frank'),
  Contact(name: 'Grace'),
  Contact(name: 'Hannah'),
  Contact(name: 'Ian'),
  Contact(name: 'Jack'),
  Contact(name: 'Kelly'),
  Contact(name: 'Liam'),
  Contact(name: 'Mia'),
  Contact(name: 'Noah'),
  Contact(name: 'Olivia'),
];
