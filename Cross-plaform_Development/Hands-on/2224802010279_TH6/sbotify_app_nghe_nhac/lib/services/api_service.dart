import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/song.dart';

class ApiService {
  static const String baseUrl = 'https://api.example.com';

  Future<List<Song>> fetchSongs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/songs'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((song) => Song.fromJson(song as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      print('Error fetching songs: $e');
      rethrow;
    }
  }

  Future<Song> fetchSongById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/songs/$id'));

      if (response.statusCode == 200) {
        return Song.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load song');
      }
    } catch (e) {
      print('Error fetching song: $e');
      rethrow;
    }
  }

  Future<List<Song>> searchSongs(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/songs/search?q=$query'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((song) => Song.fromJson(song as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to search songs');
      }
    } catch (e) {
      print('Error searching songs: $e');
      rethrow;
    }
  }
}
