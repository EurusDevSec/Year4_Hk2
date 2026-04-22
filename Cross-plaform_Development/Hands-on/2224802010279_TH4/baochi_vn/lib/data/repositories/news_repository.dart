import '../models/news.dart';
import '../services/rss_service.dart';

/// Repository for managing news data - acts as Single Source of Truth
class NewsRepository {
  // Cache for news by category
  final Map<String, List<News>> _newsCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  static const Duration _cacheDuration = Duration(hours: 1);

  NewsRepository();

  /// Get available news categories
  List<String> getCategories() {
    return RssService.getCategories();
  }

  /// Fetch news for a specific category with caching
  Future<List<News>> getNewsByCategory(
    String category, {
    bool forceRefresh = false,
  }) async {
    // Check if cache is still valid
    if (!forceRefresh && _newsCache.containsKey(category)) {
      final timestamp = _cacheTimestamps[category];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheDuration) {
        return _newsCache[category] ?? [];
      }
    }

    try {
      final rawNews = await RssService.fetchRssFeed(category);
      final newsList = rawNews.map((item) => News.fromRssItem(item)).toList();

      // Update cache
      _newsCache[category] = newsList;
      _cacheTimestamps[category] = DateTime.now();

      return newsList;
    } catch (e) {
      // Return cached data even if expired when there's an error
      if (_newsCache.containsKey(category)) {
        return _newsCache[category] ?? [];
      }
      rethrow;
    }
  }

  /// Get latest 10 news from all categories combined
  Future<List<News>> getLatestNews() async {
    try {
      final categories = getCategories();
      final allNews = <News>[];

      // Fetch news from first 2 categories for performance
      final fetchCategories = categories.take(2).toList();

      for (final category in fetchCategories) {
        try {
          final news = await getNewsByCategory(category);
          allNews.addAll(news);
        } catch (e) {
          // Continue if one category fails
          continue;
        }
      }

      // Sort by date and take latest 10
      allNews.sort((a, b) => b.pubDate.compareTo(a.pubDate));
      return allNews.take(10).toList();
    } catch (e) {
      throw Exception('Failed to fetch latest news: $e');
    }
  }

  /// Search news by title
  Future<List<News>> searchNews(String query) async {
    try {
      final categories = getCategories();
      final allNews = <News>[];

      for (final category in categories) {
        try {
          final news = await getNewsByCategory(category);
          allNews.addAll(news);
        } catch (e) {
          continue;
        }
      }

      // Filter by query
      final results = allNews
          .where(
            (news) =>
                news.title.toLowerCase().contains(query.toLowerCase()) ||
                news.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      // Sort by date
      results.sort((a, b) => b.pubDate.compareTo(a.pubDate));
      return results;
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }

  /// Clear all cache
  void clearCache() {
    _newsCache.clear();
    _cacheTimestamps.clear();
  }

  /// Clear cache for a specific category
  void clearCategoryCache(String category) {
    _newsCache.remove(category);
    _cacheTimestamps.remove(category);
  }
}
