import 'dart:convert';

class FavoriteContact {
  final String id;
  final String username;
  final String displayName;
  final DateTime addedAt;

  FavoriteContact({
    required this.id,
    required this.username,
    required this.displayName,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteContact.fromMap(Map<String, dynamic> map) {
    return FavoriteContact(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      addedAt: map['addedAt'] != null
          ? DateTime.parse(map['addedAt'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteContact.fromJson(String source) =>
      FavoriteContact.fromMap(json.decode(source));
}
