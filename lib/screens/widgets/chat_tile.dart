import 'package:flutter/material.dart';

import '../chat_screen.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final String lastMessage;
  final DateTime timestamp;
  final Map<String, dynamic> receiverData;

  const ChatTile(
      {super.key,
      required this.chatId,
      required this.lastMessage,
      required this.timestamp,
      required this.receiverData});

  @override
  Widget build(BuildContext context) {
    return lastMessage != ""
        ? Padding(
            padding: const EdgeInsets.fromLTRB(5, 7, 5, 2),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  width: 5.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.secondaryFixedDim,
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(receiverData['imageUrl']),
                ),
                title: Text(
                  receiverData['name'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
                subtitle: Text(
                  "> $lastMessage",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
                trailing: Text(
                  '${timestamp.hour}:${timestamp.minute}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ChatScreen(
                        receiverId: receiverData['uid'],
                        chatId: chatId,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const beginOffset = Offset(1.0, 0.0);
                        const endOffset = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tweenOffset =
                            Tween(begin: beginOffset, end: endOffset)
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
            ),
          )
        : Container();
  }
}
