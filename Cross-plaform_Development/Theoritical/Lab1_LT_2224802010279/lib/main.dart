import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';

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
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const MovieDetailScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile': (context) => const ProfileScreen(),
      },

      // Unknown route handler
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
