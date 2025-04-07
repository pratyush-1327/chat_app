import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  const MessageBubble({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isMe
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.secondaryFixedDim,
                    )),
            const SizedBox(height: 4),
            Text(_formatTimestamp(timestamp),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: isMe
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.inversePrimary,
                    )),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute}";
  }
}
