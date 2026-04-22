import 'package:flutter/foundation.dart';
import '../../data/models/news.dart';
import '../../data/repositories/news_repository.dart';

/// ViewModel for managing news list state
class NewsListViewModel extends ChangeNotifier {
  final NewsRepository _repository;

  List<News> _news = [];
  List<String> _categories = [];
  String _currentCategory = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<News> get news => List.unmodifiable(_news);
  List<String> get categories => List.unmodifiable(_categories);
  String get currentCategory => _currentCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NewsListViewModel({required NewsRepository repository})
    : _repository = repository {
    _initialize();
  }

  /// Initialize categories
  void _initialize() {
    _categories = _repository.getCategories();
    if (_categories.isNotEmpty) {
      _currentCategory = _categories.first;
    }
  }

  /// Load news for current category
  Future<void> loadNews({bool forceRefresh = false}) async {
    if (_currentCategory.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _news = await _repository.getNewsByCategory(
        _currentCategory,
        forceRefresh: forceRefresh,
      );
    } catch (e) {
      _error = e.toString();
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Change current category and load news
  Future<void> changeCategory(String category) async {
    if (category == _currentCategory) return;

    _currentCategory = category;
    await loadNews();
  }

  /// Refresh current news
  Future<void> refreshNews() async {
    await loadNews(forceRefresh: true);
  }

  /// Search news
  Future<List<News>> searchNews(String query) async {
    try {
      return await _repository.searchNews(query);
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  /// Clear all cache
  void clearCache() {
    _repository.clearCache();
  }
}
