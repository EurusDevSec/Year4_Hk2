import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class AudioService {
  late final AudioPlayer _audioPlayer;
  late final List<Song> _playlist;
  int _currentIndex = 0;

  AudioService() {
    _audioPlayer = AudioPlayer();
    _playlist = [];
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Song? get currentSong =>
      _currentIndex < _playlist.length ? _playlist[_currentIndex] : null;

  Future<void> loadPlaylist(List<Song> songs) async {
    _playlist.clear();
    _playlist.addAll(songs);
    await playSong(0);
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    try {
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> nextSong() async {
    if (_currentIndex < _playlist.length - 1) {
      await playSong(_currentIndex + 1);
    }
  }

  Future<void> previousSong() async {
    if (_currentIndex > 0) {
      await playSong(_currentIndex - 1);
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
