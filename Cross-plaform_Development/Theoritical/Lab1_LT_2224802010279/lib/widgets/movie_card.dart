import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool horizontal;

  const MovieCard({super.key, required this.movie, required this.horizontal});

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return _buildHorizontalCard(context);
    }
    return _buildGridCard(context);
  }

  Widget _buildHorizontalCard(BuildContext context) {
    final colorHex = int.parse('FF${movie.posterColor}', radix: 16);
    final posterColor = Color(colorHex);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.cardBorder, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      posterColor.withOpacity(0.9),
                      posterColor.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(movie.iconSymbol,
                      style: const TextStyle(fontSize: 44)),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppTheme.gold, size: 12),
                      const SizedBox(width: 3),
                      Text(movie.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    final colorHex = int.parse('FF${movie.posterColor}', radix: 16);
    final posterColor = Color(colorHex);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster area
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          posterColor.withOpacity(0.9),
                          posterColor.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(movie.iconSymbol,
                          style: const TextStyle(fontSize: 52)),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppTheme.gold, size: 11),
                          const SizedBox(width: 2),
                          Text(movie.rating.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppTheme.gold,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(movie.genre,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text('${movie.year} • ${movie.duration}',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
