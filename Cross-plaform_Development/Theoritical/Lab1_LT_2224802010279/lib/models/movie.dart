// Movie data model
class Movie {
  final int id;
  final String title;
  final String genre;
  final String description;
  final double rating;
  final int year;
  final String duration;
  final String director;
  final List<String> cast;
  final String posterColor; // hex color for gradient poster
  final String iconSymbol;  // emoji for visual
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.rating,
    required this.year,
    required this.duration,
    required this.director,
    required this.cast,
    required this.posterColor,
    required this.iconSymbol,
    this.isFavorite = false,
  });
}
