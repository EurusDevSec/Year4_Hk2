import '../models/movie.dart';

class WatchlistService {
  static final WatchlistService _instance = WatchlistService._internal();

  factory WatchlistService() {
    return _instance;
  }

  WatchlistService._internal();

  // Shared watchlist
  final List<Movie> _watchlistMovies = [];

  // Initialize with default movies
  void initialize(List<Movie> defaultMovies) {
    if (_watchlistMovies.isEmpty) {
      _watchlistMovies.addAll(defaultMovies);
    }
  }

  // Get all watchlist movies
  List<Movie> getWatchlist() {
    return List.from(_watchlistMovies);
  }

  // Add to watchlist
  void addToWatchlist(Movie movie) {
    if (!_watchlistMovies.any((m) => m.id == movie.id)) {
      _watchlistMovies.add(movie);
    }
  }

  // Remove from watchlist
  void removeFromWatchlist(Movie movie) {
    _watchlistMovies.removeWhere((m) => m.id == movie.id);
  }

  // Check if movie is in watchlist
  bool isInWatchlist(Movie movie) {
    return _watchlistMovies.any((m) => m.id == movie.id);
  }

  // Get count
  int getCount() {
    return _watchlistMovies.length;
  }

  // Clear all
  void clear() {
    _watchlistMovies.clear();
  }
}
