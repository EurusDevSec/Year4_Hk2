import 'package:flutter/foundation.dart';
import '../services/audio_service.dart';
import '../models/song.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  Song? get currentSong => _audioService.currentSong;
  List<Song> get playlist => _audioService.playlist;
  int get currentIndex => _audioService.currentIndex;

  AudioProvider() {
    _setupAudioListener();
  }

  void _setupAudioListener() {
    _audioService.audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _audioService.audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioService.audioPlayer.durationStream.listen((duration) {
      _totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });
  }

  Future<void> loadPlaylist(List<Song> songs) async {
    await _audioService.loadPlaylist(songs);
    notifyListeners();
  }

  Future<void> playSong(int index) async {
    await _audioService.playSong(index);
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.resume();
    }
    notifyListeners();
  }

  Future<void> nextSong() async {
    await _audioService.nextSong();
    notifyListeners();
  }

  Future<void> previousSong() async {
    await _audioService.previousSong();
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
