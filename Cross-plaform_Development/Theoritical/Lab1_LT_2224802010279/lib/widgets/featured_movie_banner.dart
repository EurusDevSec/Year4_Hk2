import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';

class FeaturedMovieBanner extends StatelessWidget {
  final Movie movie;

  const FeaturedMovieBanner({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final colorHex = int.parse('FF${movie.posterColor}', radix: 16);
    final posterColor = Color(colorHex);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie),
      child: Container(
        height: 260,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              posterColor.withOpacity(0.95),
              posterColor.withOpacity(0.5),
              AppTheme.background,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: posterColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: 20,
              top: 20,
              child: Text(movie.iconSymbol,
                  style: const TextStyle(fontSize: 100, height: 1)),
            ),
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      posterColor.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('🔥 TRENDING NOW',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1)),
                  ),
                  const Spacer(),
                  // Title
                  Text(movie.title,
                      style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              color: Colors.black54,
                              blurRadius: 8,
                            ),
                          ])),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppTheme.gold, size: 15),
                      const SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(width: 12),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.white54,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${movie.year}',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.white70)),
                      const SizedBox(width: 12),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.white54,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(movie.genre,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: movie,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: Text('Watch Now',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: movie,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('More Info',
                            style: GoogleFonts.inter(color: Colors.white)),
                      ),
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
}
