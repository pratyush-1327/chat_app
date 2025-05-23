import 'package:cloud_firestore/cloud_firestore.dart';

class SearchResultModel {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;

  SearchResultModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory SearchResultModel.fromMap(String id, Map<String, dynamic> data) {
    return SearchResultModel(
      userId: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  factory SearchResultModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return SearchResultModel(
      userId: snapshot.id,
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
