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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
