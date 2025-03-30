import 'package:FlutChat/models/app_user.dart';
import 'package:FlutChat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: receiver.imageUrl.isNotEmpty
            ? NetworkImage(receiver.imageUrl)
            : null,
        child: receiver.imageUrl.isEmpty ? const Icon(Icons.person) : null,
      ),
      title: Text(receiver.name),
      subtitle: Text(lastMessage),
      trailing: Text(
        "${timestamp.hour}:${timestamp.minute}",
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(
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
    );
  }
}
