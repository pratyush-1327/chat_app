import 'package:FlutChat/features/auth/presentation/login_screen.dart';
import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:FlutChat/models/app_user.dart';
import 'package:FlutChat/models/chat_room.dart';
import 'package:FlutChat/models/search_result_model.dart';
import 'package:FlutChat/features/chat/screens/chat_screen.dart';
import 'package:FlutChat/features/chat/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:FlutChat/features/chat/provider/search_provider.dart';
import 'package:FlutChat/features/chat/widgets/chat_search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final SearchController searchController;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = ref.watch(chatRepositoryProvider);
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
          child: ChatSearchBar(searchController: searchController),
        ),
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: chatProvider.getChats(user.uid),
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
                future: chatProvider.getReceiverData(chat.users),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          searchController.openView();
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
