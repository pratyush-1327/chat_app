import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> users;
  final String lastMessage;
  final DateTime timestamp;

  ChatRoom({
    required this.id,
    required this.users,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatRoom.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoom(
      id: id,
      users: List<String>.from(map['user']),
      lastMessage: map['lastMessage'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ChatRoom.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChatRoom(
      id: snapshot.id,
      users: data?['user'] is Iterable ? List<String>.from(data?['user']) : [],
      lastMessage: data?['lastMessage'] ?? '',
      timestamp: (data?['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user': users,
      'lastMessage': lastMessage,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'user': users,
      'lastMessage': lastMessage,
      'timestamp': Timestamp.fromDate(timestamp), 
    };
  }
}
