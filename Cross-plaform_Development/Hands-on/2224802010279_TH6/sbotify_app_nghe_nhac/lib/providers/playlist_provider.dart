import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../data/sample_data.dart';

class PlaylistProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();

  List<Song> _allSongs = [];
  List<Song> _searchResults = [];
  List<Playlist> _userPlaylists = [];
  bool _isLoading = false;
  String? _error;

  List<Song> get allSongs => _allSongs;
  List<Song> get searchResults => _searchResults;
  List<Playlist> get userPlaylists => _userPlaylists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSongs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Use sample data instead of API
      await Future.delayed(const Duration(milliseconds: 300));
      _allSongs = SampleData.songs;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Use sample data search
      await Future.delayed(const Duration(milliseconds: 200));
      _searchResults = SampleData.searchSongs(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPlaylist(
    String name,
    String description,
    String userId,
  ) async {
    try {
      final playlist = Playlist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        songs: [],
        createdAt: DateTime.now(),
      );

      await _firebaseService.createPlaylist(playlist, userId);
      _userPlaylists.add(playlist);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadUserPlaylists(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userPlaylists = await _firebaseService.getUserPlaylists(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
}
