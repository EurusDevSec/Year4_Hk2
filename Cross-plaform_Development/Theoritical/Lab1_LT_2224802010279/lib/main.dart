import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/categories_screen.dart';
import 'models/movie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CineMaxApp());
}

class CineMaxApp extends StatelessWidget {
  const CineMaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineMax',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,

      // ──────────────────────────────────────────────
      // Named Routes – Navigation by name
      // ──────────────────────────────────────────────
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/detail': (context) {
          final movie = ModalRoute.of(context)!.settings.arguments as Movie?;
          return MovieDetailScreen(movie: movie);
        },
        '/categories': (context) => const CategoriesScreen(),
      },

      // Unknown route handler
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }
}
