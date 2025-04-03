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
              barElevation: MaterialStateProperty.all(0.0),
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
              leading: CircleAvatar(
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image(
                    image: NetworkImage(contact.avatarUrl),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
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
  Contact(name: 'Alicia', avatarUrl: 'https://picsum.photos/100/100'),
  Contact(name: 'Anthony', avatarUrl: 'https://picsum.photos/100/100'),
  Contact(name: 'Ben', avatarUrl: 'https://picsum.photos/100/100'),
  Contact(name: 'Bryan', avatarUrl: 'https://picsum.photos/100/100'),
  Contact(name: 'Brianna', avatarUrl: 'https://picsum.photos/100/100'),
  Contact(name: 'Cindy', avatarUrl: 'https://picsum.photos/100/100'),
  Contact(name: 'Daisy', avatarUrl: 'https://picsum.photos/100/100'),
  Contact(name: 'Diana', avatarUrl: 'https://picsum.photos/100/100'),
];
