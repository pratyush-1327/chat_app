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
      imageUrl: data['imageUrl'] ??
          '', // Changed from 'imageUrl' to 'imageUrl' to match AppUser model
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
