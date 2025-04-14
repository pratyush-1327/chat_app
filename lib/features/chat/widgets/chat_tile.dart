import 'package:FlutChat/models/app_user.dart';
import 'package:FlutChat/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatTile extends ConsumerWidget {
  final String chatId;
  final String lastMessage;
  final DateTime timestamp;
  final AppUser receiver;

  const ChatTile({
    super.key,
    required this.chatId,
    required this.lastMessage,
    required this.timestamp,
    required this.receiver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: receiver.imageUrl.isNotEmpty
              ? NetworkImage(receiver.imageUrl)
              : null,
          child: receiver.imageUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Text(
            receiver.name,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20),
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color:
                  Theme.of(context).colorScheme.inverseSurface.withAlpha(170)),
        ),
        trailing: Text("${timestamp.hour}:${timestamp.minute}",
            style: Theme.of(context).textTheme.bodyMedium),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  spacing: 20,
                  children: [
                    Icon(
                      Icons.delete_forever_outlined,
                      size: 30,
                    ),
                    Text("Delete Conversation"),
                  ],
                ),
                content: Text(
                  "This conversation will be removed from all your synced devices. This action cannot be undone.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref.read(chatRepositoryProvider).deleteChat(chatId);
                    },
                  ),
                ],
              );
            },
          );
        },
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ChatScreen(
                receiverId: receiver.id,
                chatId: chatId,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const beginOffset = Offset(1.0, 0.0);
                const endOffset = Offset.zero;
                const curve = Curves.easeInOut;

                var tweenOffset = Tween(begin: beginOffset, end: endOffset)
                    .chain(CurveTween(curve: curve));
                var slideAnimation = animation.drive(tweenOffset);

                var fadeAnimation =
                    Tween(begin: 0.0, end: 1.0).animate(animation);

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
      ),
    );
  }
}
