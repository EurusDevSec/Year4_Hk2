/// Model representing a news article
class News {
  final String id;
  final String title;
  final String description;
  final String link;
  final String? imageUrl;
  final String? category;
  final DateTime pubDate;
  final String? author;

  const News({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    this.imageUrl,
    this.category,
    required this.pubDate,
    this.author,
  });

  /// Factory constructor for creating News from RSS feed item
  factory News.fromRssItem(Map<String, dynamic> item) {
    return News(
      id: item['link'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: item['title'] ?? 'No title',
      description: item['description'] ?? 'No description',
      link: item['link'] ?? '',
      imageUrl: item['imageUrl'],
      category: item['category'],
      pubDate: item['pubDate'] ?? DateTime.now(),
      author: item['author'],
    );
  }

  /// Convert News to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'link': link,
      'imageUrl': imageUrl,
      'category': category,
      'pubDate': pubDate.toIso8601String(),
      'author': author,
    };
  }

  /// Create News from JSON map
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      link: json['link'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
      pubDate: DateTime.parse(json['pubDate'] as String),
      author: json['author'] as String?,
    );
  }
}
