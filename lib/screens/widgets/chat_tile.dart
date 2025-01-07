import 'package:flutter/material.dart';

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
        ? ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(receiverData['imageUrl']),
            ),
            title: Text(receiverData['name']),
            subtitle: Text(lastMessage),
            trailing: Text(
              '${timestamp.hour}:${timestamp.minute}',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(),));
            },
          )
        : Container();
  }
}
