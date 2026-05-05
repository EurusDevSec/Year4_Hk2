import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPauseTap;
  final VoidCallback onNextTap;
  final VoidCallback onPreviousTap;

  const PlayerControls({
    Key? key,
    required this.isPlaying,
    required this.onPlayPauseTap,
    required this.onNextTap,
    required this.onPreviousTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 36,
          onPressed: onPreviousTap,
        ),
        const SizedBox(width: 24),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            iconSize: 48,
            onPressed: onPlayPauseTap,
          ),
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 36,
          onPressed: onNextTap,
        ),
      ],
    );
  }
}
