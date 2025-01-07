import 'package:chat_app/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;

  const UserTile(
      {super.key,
      required this.userId,
      required this.name,
      required this.email,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Text(email),
      onTap: () async {
        final chatId = await chatProvider.getChatRoom(userId) ??
            await chatProvider.createChatRoom(userId);
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation, secondaryAnimation) =>
        //         ChatScreen(),
        //     transitionsBuilder:
        //         (context, animation, secondaryAnimation, child) {
        //       const beginOffset = Offset(1.0, 0.0);
        //       const endOffset = Offset.zero;
        //       const curve = Curves.easeInOut;

        //       var tweenOffset = Tween(begin: beginOffset, end: endOffset)
        //           .chain(CurveTween(curve: curve));
        //       var slideAnimation = animation.drive(tweenOffset);

        //       var fadeAnimation =
        //           Tween(begin: 0.0, end: 1.0).animate(animation);

        //       return SlideTransition(
        //         position: slideAnimation,
        //         child: FadeTransition(
        //           opacity: fadeAnimation,
        //           child: child,
        //         ),
        //       );
        //     },
        //   ),
        // );
      },
    );
  }
}
