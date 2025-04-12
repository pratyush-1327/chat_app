import 'package:FlutChat/features/chat/provider/search_provider.dart';
import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
// import 'package:FlutChat/models/search_result_model.dart';
import 'package:FlutChat/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatSearchBar extends ConsumerWidget {
  const ChatSearchBar({super.key, required this.searchController});

  final SearchController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchAnchor.bar(
      barElevation: WidgetStateProperty.all(0),
      barHintText: "Search users...",
      searchController: searchController,
      onChanged: (query) {
        // Use addPostFrameCallback to avoid modifying state during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ref.read(searchProvider.notifier).state != query) {
            ref.read(searchProvider.notifier).state = query;
          }
        });
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          Consumer(
            builder: (context, ref, child) {
              final searchQuery = ref.watch(searchProvider);

              final searchResults = ref.watch(searchResultsProvider);
              final chatRepo = ref.read(chatRepositoryProvider);

              return searchResults.when(
                data: (users) {
                  if (searchQuery.isEmpty) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Start typing to search"),
                    ));
                  }
                  if (users.isEmpty) {
                    return const Center(
                        child: Padding(
                      // Add padding
                      padding: EdgeInsets.all(16.0),
                      child: Text("No users found"),
                    ));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final userResult = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          backgroundImage: (userResult.imageUrl != null &&
                                  userResult.imageUrl.isNotEmpty)
                              ? NetworkImage(userResult.imageUrl)
                              : null,
                          child: (userResult.imageUrl == null ||
                                  userResult.imageUrl.isEmpty)
                              ? Icon(Icons.person,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)
                              : null,
                        ),
                        title: Text(userResult.name),
                        subtitle: Text(userResult.email),
                        onTap: () async {
                          controller.closeView(userResult.name);

                          final chatId = await chatRepo
                                  .getChatRoom(userResult.userId) ??
                              await chatRepo.createChatRoom(userResult.userId);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ChatScreen(
                                chatId: chatId,
                                receiverId: userResult.userId,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const beginOffset = Offset(1.0, 0.0);
                                const endOffset = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tweenOffset =
                                    Tween(begin: beginOffset, end: endOffset)
                                        .chain(CurveTween(curve: curve));
                                var slideAnimation =
                                    animation.drive(tweenOffset);

                                var fadeAnimation = Tween(begin: 0.0, end: 1.0)
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
                  );
                },
                // Return a single widget for loading/error states
                loading: () => const Center(
                    child: Padding(
                  // Add padding
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )),
                error: (err, stack) => Center(
                    child: Padding(
                  // Add padding
                  padding: EdgeInsets.all(16.0),
                  child: Text('Error: $err'),
                )),
              );
            },
          ),
        ]; // End list wrap
      },
    );
  }
}
