import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/movie_data.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../services/watchlist_service.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final WatchlistService _watchlistService = WatchlistService();

  @override
  void initState() {
    super.initState();
    // Initialize with default movies on first load
    if (_watchlistService.getCount() == 0) {
      _watchlistService.initialize([
        MovieData.getAllMovies()[0], // Interstellar
        MovieData.getAllMovies()[1], // The Dark Knight
        MovieData.getAllMovies()[3], // Parasite
        MovieData.getAllMovies()[4], // Inception
      ]);
    }
    _filteredMovies = _watchlistService.getWatchlist();
    _sortWatchlist();
  }

  late List<Movie> _filteredMovies;
  String _sortBy = 'added'; // added, rating, year

  void _sortWatchlist() {
    List<Movie> movies = _watchlistService.getWatchlist();
    switch (_sortBy) {
      case 'rating':
        movies.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'year':
        movies.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'added':
      default:
        movies = _watchlistService.getWatchlist();
    }
    _filteredMovies = movies;
  }

  void _removeFromWatchlist(Movie movie) {
    _watchlistService.removeFromWatchlist(movie);
    setState(() {
      _filteredMovies = _watchlistService.getWatchlist();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${movie.title} removed from watchlist',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.primary,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Always refresh from service when building
    _filteredMovies = _watchlistService.getWatchlist();
    _sortWatchlist();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: const SizedBox.shrink(),
        title: Text(
          'My Watchlist',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            color: AppTheme.surface,
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _sortWatchlist();
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'added',
                child: Text(
                  'Recently Added',
                  style: GoogleFonts.inter(color: AppTheme.textPrimary),
                ),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Text(
                  'Highest Rated',
                  style: GoogleFonts.inter(color: AppTheme.textPrimary),
                ),
              ),
              PopupMenuItem(
                value: 'year',
                child: Text(
                  'Newest First',
                  style: GoogleFonts.inter(color: AppTheme.textPrimary),
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.sort_rounded, color: AppTheme.primary),
            ),
          ),
        ],
      ),
      body: _watchlistService.getWatchlist().isEmpty
          ? _buildEmptyState()
          : CustomScrollView(
              slivers: [
                // Stats
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _watchlistService
                                      .getWatchlist()
                                      .length
                                      .toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total Movies',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${(_watchlistService.getWatchlist().fold<double>(0, (sum, m) => sum + m.rating) / _watchlistService.getWatchlist().length).toStringAsFixed(1)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Avg Rating',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Watchlist Items
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final movie = _filteredMovies[index];
                      return _buildWatchlistItem(movie, context);
                    }, childCount: _filteredMovies.length),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_outline_rounded,
              size: 50,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Your watchlist is empty',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add movies to your watchlist to keep track\nof films you want to watch',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/categories'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Browse Movies',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistItem(Movie movie, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: movie),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(
          children: [
            // Poster
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${movie.posterColor}')),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  movie.iconSymbol,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppTheme.secondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${movie.year}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.genre,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Remove Button
            GestureDetector(
              onTap: () => _removeFromWatchlist(movie),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
