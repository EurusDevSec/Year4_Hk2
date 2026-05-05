import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/player_controls.dart';
import '../../widgets/progress_slider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đang phát'), elevation: 0),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, _) {
          final currentSong = audioProvider.currentSong;

          if (currentSong == null) {
            return const Center(child: Text('Không có bài hát'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Album art
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: currentSong.imageUrl,
                      height: 300,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Icon(Icons.music_note, size: 100),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, size: 100),
                      ),
                    ),
                  ),
                ),

                // Song info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentSong.artist,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Progress slider
                ProgressSlider(
                  currentPosition: audioProvider.currentPosition,
                  totalDuration: audioProvider.totalDuration,
                  onSeek: (duration) {
                    audioProvider.seek(duration);
                  },
                ),

                const SizedBox(height: 32),

                // Player controls
                PlayerControls(
                  isPlaying: audioProvider.isPlaying,
                  onPlayPauseTap: () {
                    audioProvider.togglePlayPause();
                  },
                  onNextTap: () {
                    audioProvider.nextSong();
                  },
                  onPreviousTap: () {
                    audioProvider.previousSong();
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
