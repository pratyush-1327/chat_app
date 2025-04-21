import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String messageBody;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.messageBody,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      messageBody: map['messageBody'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ChatMessage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChatMessage(
      senderId: data?['senderId'] ?? '',
      receiverId: data?['receiverId'] ?? '',
      messageBody: data?['messageBody'] ?? '',
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageBody': messageBody,
    };
  }

  ChatMessage copyWith({
    String? senderId,
    String? receiverId,
    String? messageBody,
    DateTime? timestamp,
    dynamic firestoreTimestamp,
  }) {
    return ChatMessage(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      messageBody: messageBody ?? this.messageBody,
      timestamp: firestoreTimestamp is FieldValue
          ? DateTime.now()
          : (timestamp ?? this.timestamp),
    );
  }
}
