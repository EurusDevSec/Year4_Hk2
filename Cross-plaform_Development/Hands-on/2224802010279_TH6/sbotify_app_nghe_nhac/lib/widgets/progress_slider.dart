import 'package:flutter/material.dart';

class ProgressSlider extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final ValueChanged<Duration> onSeek;

  const ProgressSlider({
    Key? key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onSeek,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: currentPosition.inSeconds.toDouble(),
            max: totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              onSeek(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.grey[300],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(currentPosition),
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                _formatDuration(totalDuration),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
