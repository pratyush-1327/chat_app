import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:FlutChat/models/search_result_model.dart';
import 'package:FlutChat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final searchProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StreamProvider<List<SearchResultModel>>((ref) {
  final query = ref.watch(searchProvider);
  if (query.isEmpty) return const Stream.empty();
  final chatRepository = ref.read(chatRepositoryProvider);
  return chatRepository.searchUsers(query);
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final chatProvider = ref.read(chatRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Search Users")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) =>
                  ref.read(searchProvider.notifier).state = value,
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: searchResults.when(
                data: (users) => users.isEmpty
                    ? const Center(child: Text("No users found"))
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              backgroundImage: (user.imageUrl != null &&
                                      user.imageUrl.isNotEmpty)
                                  ? NetworkImage(user.imageUrl)
                                  : null,
                              child: (user.imageUrl == null ||
                                      user.imageUrl.isEmpty)
                                  ? Icon(Icons.person,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)
                                  : null,
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            onTap: () async {
                              final chatId =
                                  await chatProvider.getChatRoom(user.userId) ??
                                      await chatProvider
                                          .createChatRoom(user.userId);
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ChatScreen(
                                    chatId: chatId,
                                    receiverId: user.userId,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const beginOffset = Offset(1.0, 0.0);
                                    const endOffset = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tweenOffset = Tween(
                                            begin: beginOffset, end: endOffset)
                                        .chain(CurveTween(curve: curve));
                                    var slideAnimation =
                                        animation.drive(tweenOffset);

                                    var fadeAnimation =
                                        Tween(begin: 0.0, end: 1.0)
                                            .animate(animation);

                                    return SlideTransition(
                                      position: slideAnimation,
                                      child: FadeTransition(
                                        opacity: fadeAnimation,
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
