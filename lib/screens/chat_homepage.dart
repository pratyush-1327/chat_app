import 'package:FlutChat/features/auth/presentation/login_screen.dart';
import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:FlutChat/models/app_user.dart';
import 'package:FlutChat/models/chat_room.dart';
import 'package:FlutChat/models/search_result_model.dart';
import 'package:FlutChat/screens/chat_screen.dart';
import 'package:FlutChat/screens/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final searchProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StreamProvider<List<SearchResultModel>>((ref) {
  final query = ref.watch(searchProvider);

  if (query.trim().isEmpty) return Stream.value([]);
  final chatRepository = ref.read(chatRepositoryProvider);
  return chatRepository.searchUsers(query);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<AppUser?> getReceiverData(List<String> users) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final receiverId =
        users.firstWhere((id) => id != currentUser?.uid, orElse: () => '');
    if (receiverId.isEmpty) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    if (doc.exists) {
      return AppUser.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 10),
          child: SearchAnchor.bar(
            barElevation: WidgetStateProperty.all(0),
            barHintText: "Search users...",
            onChanged: (query) {
              // Use addPostFrameCallback to avoid modifying state during build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ref.read(searchProvider.notifier).state != query) {
                  ref.read(searchProvider.notifier).state = query;
                }
              });
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return [
                Consumer(
                  builder: (context, ref, child) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (ref.read(searchProvider.notifier).state !=
                          controller.text) {
                        ref.read(searchProvider.notifier).state =
                            controller.text;
                      }
                    });

                    final searchResults = ref.watch(searchResultsProvider);
                    final chatRepo = ref.read(chatRepositoryProvider);

                    return searchResults.when(
                      data: (users) {
                        if (controller.text.isEmpty) {
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
                                    await chatRepo
                                        .createChatRoom(userResult.userId);
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ChatScreen(
                                      chatId: chatId,
                                      receiverId: userResult.userId,
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const beginOffset = Offset(1.0, 0.0);
                                      const endOffset = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tweenOffset = Tween(
                                              begin: beginOffset,
                                              end: endOffset)
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
          ),
        ),
        actions: [
          // Optional: Add other actions if needed
        ],
      ),
      // Main body showing existing chats
      body: StreamBuilder<List<ChatRoom>>(
        stream: chatRepository
            .getChats(user.uid), // Use the instance from the top scope
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats available'));
          }
          final chatRooms = snapshot.data!;
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chat = chatRooms[index];
              return FutureBuilder<AppUser?>(
                future: getReceiverData(chat.users),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading..."));
                  }
                  final receiver = userSnapshot.data;
                  if (receiver == null) {
                    return const ListTile(title: Text("User not found"));
                  }
                  return ChatTile(
                    chatId: chat.id,
                    lastMessage: chat.lastMessage,
                    timestamp: chat.timestamp,
                    receiver: receiver,
                  );
                },
              );
            },
          );
        },
      ),
      // Removed FloatingActionButton as search is now in AppBar
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const SearchScreen()),
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   foregroundColor: Theme.of(context).colorScheme.surfaceBright,
      //   child: const Icon(Icons.edit),
      // ),
    );
  }
}
