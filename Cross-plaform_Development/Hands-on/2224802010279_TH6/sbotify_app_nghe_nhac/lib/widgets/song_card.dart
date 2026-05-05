import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const SongCard({
    Key? key,
    required this.song,
    required this.onTap,
    this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // Ensure tappable area
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Song thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(
                4,
              ), // Slightly rounded corners like Spotify
              child: CachedNetworkImage(
                imageUrl: song.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.grey),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[800],
                  child: const Icon(Icons.error, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            // Favorite button + More Options
            if (onFavoriteTap != null)
              IconButton(
                icon: Icon(
                  song.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: song.isFavorite
                      ? const Color(0xFF1DB954)
                      : Colors.grey[400],
                  size: 24,
                ),
                onPressed: onFavoriteTap,
              ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey[400]),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
