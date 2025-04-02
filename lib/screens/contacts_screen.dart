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
        title: SearchAnchor.bar(
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
                    ))
                .toList();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(contact.name[0]),
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
  final String avatarUrl;

  Contact({required this.name, required this.avatarUrl});
}

final List<Contact> contacts = [
  Contact(name: 'Alicia', avatarUrl: ''),
  Contact(name: 'Anthony', avatarUrl: ''),
  Contact(name: 'Ben', avatarUrl: ''),
  Contact(name: 'Bryan', avatarUrl: ''),
  Contact(name: 'Brianna', avatarUrl: ''),
  Contact(name: 'Cindy', avatarUrl: ''),
  Contact(name: 'Daisy', avatarUrl: ''),
  Contact(name: 'Diana', avatarUrl: ''),
];
