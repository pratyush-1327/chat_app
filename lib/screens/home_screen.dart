import 'package:FlutChat/features/auth/presentation/login_screen.dart';
import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:FlutChat/models/app_user.dart';
import 'package:FlutChat/models/chat_room.dart';
import 'package:FlutChat/screens/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'search_screen.dart';

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
        title: const Text("FlutChat"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: chatRepository.getChats(user.uid),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surfaceBright,
        child: const Icon(Icons.search_rounded),
      ),
    );
  }
}
