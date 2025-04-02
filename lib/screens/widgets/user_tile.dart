import 'package:FlutChat/features/chat/repositories/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
// import '../../features/chat/repositories/chat_repository.dart';

class UserTile extends ConsumerWidget {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;

  const UserTile({
    super.key,
    required this.userId,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRepository = ref.read(chatRepositoryProvider);

    return ListTile(
      leading: CircleAvatar(
        radius: 6.w, // Changed from 25
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Text(email),
      onTap: () async {
        final chatId = await chatRepository.getChatRoom(userId) ??
            await chatRepository.createChatRoom(userId);
        // Implement navigation logic here
      },
    );
  }
}
