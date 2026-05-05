class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final List<String> favoriteIds;
  final List<String> playlistIds;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.favoriteIds = const [],
    this.playlistIds = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? 'User',
      avatarUrl: json['avatarUrl'],
      favoriteIds: List<String>.from(json['favoriteIds'] ?? []),
      playlistIds: List<String>.from(json['playlistIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'favoriteIds': favoriteIds,
      'playlistIds': playlistIds,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    List<String>? favoriteIds,
    List<String>? playlistIds,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      playlistIds: playlistIds ?? this.playlistIds,
    );
  }
}
