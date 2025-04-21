import 'package:FlutChat/models/chat_message.dart';
import 'package:FlutChat/models/chat_room.dart';
import 'package:FlutChat/models/search_result_model.dart';
import 'package:FlutChat/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider((ref) => ChatProvider());

class ChatProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  final _chatRoomConverter = (
    fromFirestore: ChatRoom.fromFirestore,
    toFirestore: (ChatRoom room, _) => room.toFirestore(),
  );

  final _chatMessageConverter = (
    fromFirestore: ChatMessage.fromFirestore,
    toFirestore: (ChatMessage msg, _) => msg.toFirestore(),
  );

  final _appUserConverter = (
    fromFirestore: AppUser.fromFirestore,
    toFirestore: (AppUser user, _) => user.toFirestore(),
  );

  final _searchResultConverter = (
    fromFirestore: SearchResultModel.fromFirestore,
    toFirestore: (SearchResultModel result, _) => result.toFirestore(),
  );


  Stream<List<ChatRoom>> getChats(String userId) {
    return _firestore
        .collection("chats")
        .withConverter<ChatRoom>(
              fromFirestore: _chatRoomConverter.fromFirestore,
              toFirestore: _chatRoomConverter.toFirestore,
            )
        .where('user', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .withConverter<ChatMessage>(
              fromFirestore: _chatMessageConverter.fromFirestore,
              toFirestore: _chatMessageConverter.toFirestore,
            )
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> sendMessage(String chatId, ChatMessage message) async {

    final messageData = message.toFirestore()
      ..['timestamp'] = FieldValue.serverTimestamp();


    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);


    await _firestore.collection('chats').doc(chatId).set({
      'user': [message.senderId, message.receiverId],
      'lastMessage': message.messageBody,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }



  Future<String?> getChatRoom(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatQuery = await _firestore
          .collection('chats')
          .where('user', arrayContains: currentUser.uid)
          .get();
      final chats = chatQuery.docs
          .where((chat) => chat['user'].contains(receiverId))
          .toList();
      if (chats.isNotEmpty) {
        return chats.first.id;
      }
    }
    return null;
  }

  Future<AppUser?> getReceiverData(List<String> users) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final receiverId =
        users.firstWhere((id) => id != currentUser?.uid, orElse: () => '');
    if (receiverId.isEmpty) return null;

    final docSnap = await _firestore
        .collection('users')
        .doc(receiverId)
        .withConverter<AppUser>(
              fromFirestore: _appUserConverter.fromFirestore,
              toFirestore: _appUserConverter.toFirestore,
            )
        .get();

    return docSnap.data();
  }


  Future<String> createChatRoom(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatRoomRef = await _firestore.collection('chats').add({
        'user': [currentUser.uid, receiverId],
        'lastMessage': '',
        'timestamp': FieldValue.serverTimestamp(),
      });
      return chatRoomRef.id;
    }
    throw Exception('Current User is null');
  }

  Stream<List<SearchResultModel>> searchUsers(String query) {
    return _firestore
        .collection('users')
        .withConverter<SearchResultModel>(
              fromFirestore: _searchResultConverter.fromFirestore,
              toFirestore: _searchResultConverter.toFirestore,
            )
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }


  Future<void> deleteChat(String chatId) async {
    await _firestore.collection('chats').doc(chatId).delete();

    final messages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (final message in messages.docs) {
      await message.reference.delete();
    }
  }
}
