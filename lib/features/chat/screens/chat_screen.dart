import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:FlutChat/models/chat_message.dart';
import 'package:FlutChat/models/app_user.dart';
// import 'package:FlutChat/screens/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? chatId;
  final String receiverId;

  const ChatScreen({super.key, this.chatId, required this.receiverId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String? chatId;
  AppUser? receiver;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    getCurrentUser();
    fetchReceiverData();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  Future<void> fetchReceiverData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.receiverId)
        .get();
    if (doc.exists) {
      setState(() {
        receiver = AppUser.fromMap(doc.id, doc.data()!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    final TextEditingController _textController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        title: receiver != null
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: receiver!.imageUrl.isNotEmpty
                        ? NetworkImage(receiver!.imageUrl)
                        : null,
                    child: receiver!.imageUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    receiver!.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                ],
              )
            : const Text("Loading..."),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                MessageStream(chatId: chatId ?? "", userId: loggedInUser!.uid),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                            hintText: "Send message...",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      onPressed: () async {
                        if (_textController.text.isNotEmpty) {
                          if (chatId == null || chatId!.isEmpty) {
                            chatId = await chatRepository
                                .createChatRoom(widget.receiverId);
                          }
                          if (chatId != null) {
                            final message = ChatMessage(
                              messageBody: _textController.text,
                              senderId: loggedInUser!.uid,
                              receiverId: widget.receiverId,
                              timestamp: DateTime.now(),
                            );
                            chatRepository.sendMessage(chatId!, message);
                            _textController.clear();
                          }
                        }
                      },
                      icon: Icon(Icons.send),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final String chatId;
  final String userId;

  const MessageStream({super.key, required this.chatId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data!.docs
            .map((doc) =>
                ChatMessage.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return MessageBubble(
              sender: message.senderId,
              text: message.messageBody,
              isMe: userId == message.senderId,
              timestamp: message.timestamp,
            );
          },
        );
      },
    );
  }
}
