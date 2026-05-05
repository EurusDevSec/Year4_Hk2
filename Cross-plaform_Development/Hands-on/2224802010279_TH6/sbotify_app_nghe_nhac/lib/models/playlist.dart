import 'song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final List<Song> songs;
  final DateTime createdAt;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.songs,
    required this.createdAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'New Playlist',
      description: json['description'] ?? '',
      songs:
          (json['songs'] as List<dynamic>?)
              ?.map((song) => Song.fromJson(song as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'songs': songs.map((song) => song.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get songCount => songs.length;
}
