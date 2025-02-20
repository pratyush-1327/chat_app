import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats(String userId) {
    return _firestore
        .collection("chats")
        .where('user', arrayContains: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> searchUsers(String query) {
    debugPrint('Searching for users with query: $query');
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots();
  }

  Future<void> sendMessage(
      String chatId, String message, String receiverId) async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': currentUser.uid,
        'receiverId': receiverId,
        'messageBody': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await _firestore.collection('chats').doc(chatId).set({
        'user': [currentUser.uid, receiverId],
        'lastMessage': message,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
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
        debugPrint('Chat found: ${chats.first.id}');
        return chats.first.id;
      } else {
        debugPrint('No chat found for receiverId: $receiverId');
      }
    }
    return null;
  }

  Future<String> createChatRoom(String receiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatRoom = await _firestore.collection('chats').add({
        'user': [currentUser.uid, receiverId],
        'lastMessage': '',
        'timestamp': FieldValue.serverTimestamp(),
      });
      return chatRoom.id;
    }
    throw Exception('Current User is null');
  }
}
