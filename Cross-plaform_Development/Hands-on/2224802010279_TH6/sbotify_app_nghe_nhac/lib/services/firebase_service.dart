import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../models/user.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User operations
  Future<void> saveUser(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  Future<AppUser?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data() ?? {});
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Songs operations
  Future<List<Song>> getSongs() async {
    try {
      final snapshot = await _firestore.collection('songs').get();
      return snapshot.docs
          .map((doc) => Song.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching songs: $e');
      return [];
    }
  }

  // Playlist operations
  Future<void> createPlaylist(Playlist playlist, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('playlists')
          .doc(playlist.id)
          .set(playlist.toJson());
    } catch (e) {
      print('Error creating playlist: $e');
      rethrow;
    }
  }

  Future<List<Playlist>> getUserPlaylists(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('playlists')
          .get();
      return snapshot.docs
          .map((doc) => Playlist.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching playlists: $e');
      return [];
    }
  }

  // Favorites operations
  Future<void> addToFavorites(String userId, String songId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favoriteIds': FieldValue.arrayUnion([songId]),
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String userId, String songId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favoriteIds': FieldValue.arrayRemove([songId]),
      });
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }
}
