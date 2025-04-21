import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map['name'],
      email: map['email'],
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AppUser(
      id: snapshot.id,
      name: data?['name'] ?? '',
      email: data?['email'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
