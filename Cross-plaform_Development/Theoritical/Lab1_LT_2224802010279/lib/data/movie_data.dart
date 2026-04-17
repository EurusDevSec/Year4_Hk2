import '../models/movie.dart';

class MovieData {
  static List<Movie> getAllMovies() {
    return [
      Movie(
        id: 1,
        title: 'Interstellar',
        genre: 'Sci-Fi',
        description:
            'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival. Set in a dystopian future where humanity is struggling to survive, this epic tale of love, sacrifice, and time bends the boundaries of human experience.',
        rating: 9.2,
        year: 2014,
        duration: '2h 49m',
        director: 'Christopher Nolan',
        cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
        posterColor: '1a1a2e',
        iconSymbol: '🌌',
      ),
      Movie(
        id: 2,
        title: 'The Dark Knight',
        genre: 'Action',
        description:
            'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice. A gripping tale of heroism and villainy.',
        rating: 9.0,
        year: 2008,
        duration: '2h 32m',
        director: 'Christopher Nolan',
        cast: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'],
        posterColor: '0d0d0d',
        iconSymbol: '🦇',
      ),
      Movie(
        id: 3,
        title: 'Avatar: The Way of Water',
        genre: 'Adventure',
        description:
            'Jake and Neytiri have formed a family and are doing everything to stay together. However, they must leave their home and explore Pandora\'s regions to wage battles against the RDA. A visually stunning journey into an alien world.',
        rating: 7.6,
        year: 2022,
        duration: '3h 12m',
        director: 'James Cameron',
        cast: ['Sam Worthington', 'Zoe Saldana', 'Sigourney Weaver'],
        posterColor: '003d5c',
        iconSymbol: '🌊',
      ),
      Movie(
        id: 4,
        title: 'Parasite',
        genre: 'Thriller',
        description:
            'All four members of a Ki-taek\'s family are unemployed, living in a small semi-basement apartment. Then, by a twist of fate, they find jobs working for the Park family. A sharp, suspenseful thriller about class inequality.',
        rating: 8.5,
        year: 2019,
        duration: '2h 12m',
        director: 'Bong Joon-ho',
        cast: ['Song Kang-ho', 'Lee Sun-kyun', 'Cho Yeo-jeong'],
        posterColor: '1b2838',
        iconSymbol: '🏠',
      ),
      Movie(
        id: 5,
        title: 'Dune: Part Two',
        genre: 'Sci-Fi',
        description:
            'Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the known universe.',
        rating: 8.8,
        year: 2024,
        duration: '2h 46m',
        director: 'Denis Villeneuve',
        cast: ['Timothée Chalamet', 'Zendaya', 'Rebecca Ferguson'],
        posterColor: '3d2b1d',
        iconSymbol: '🏜️',
      ),
      Movie(
        id: 6,
        title: 'Oppenheimer',
        genre: 'Drama',
        description:
            'The story of J. Robert Oppenheimer\'s role in the development of the atomic bomb during World War II. A biographical thriller that explores the moral complexities of scientific discovery and its devastating consequences.',
        rating: 8.9,
        year: 2023,
        duration: '3h 0m',
        director: 'Christopher Nolan',
        cast: ['Cillian Murphy', 'Emily Blunt', 'Matt Damon'],
        posterColor: '2c1810',
        iconSymbol: '☢️',
      ),
      Movie(
        id: 7,
        title: 'Spider-Man: No Way Home',
        genre: 'Action',
        description:
            'With Spider-Man\'s identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear, forcing Peter to discover what it truly means to be Spider-Man.',
        rating: 8.3,
        year: 2021,
        duration: '2h 28m',
        director: 'Jon Watts',
        cast: ['Tom Holland', 'Zendaya', 'Benedict Cumberbatch'],
        posterColor: '1a0033',
        iconSymbol: '🕷️',
      ),
      Movie(
        id: 8,
        title: 'Everything Everywhere',
        genre: 'Comedy',
        description:
            'An aging Chinese immigrant is swept up in an insane adventure, where she alone can save the world by exploring other universes connecting with the lives she could have led. A dazzling multiverse adventure.',
        rating: 7.8,
        year: 2022,
        duration: '2h 19m',
        director: 'The Daniels',
        cast: ['Michelle Yeoh', 'Stephanie Hsu', 'Ke Huy Quan'],
        posterColor: '1a1a00',
        iconSymbol: '🌀',
      ),
    ];
  }

  static List<Movie> getTrendingMovies() {
    final all = getAllMovies();
    return [all[0], all[4], all[5], all[6]];
  }

  static List<Movie> getTopRatedMovies() {
    final all = getAllMovies();
    all.sort((a, b) => b.rating.compareTo(a.rating));
    return all.take(5).toList();
  }

  static List<String> getGenres() {
    return ['All', 'Sci-Fi', 'Action', 'Adventure', 'Thriller', 'Drama', 'Comedy'];
  }

  static List<Movie> getMoviesByGenre(String genre) {
    if (genre == 'All') return getAllMovies();
    return getAllMovies().where((m) => m.genre == genre).toList();
  }
}
