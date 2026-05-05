class Song {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;
  final Duration duration;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
    this.isFavorite = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown Artist',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      duration: Duration(seconds: json['duration'] ?? 0),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'duration': duration.inSeconds,
      'isFavorite': isFavorite,
    };
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? imageUrl,
    String? audioUrl,
    Duration? duration,
    bool? isFavorite,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
