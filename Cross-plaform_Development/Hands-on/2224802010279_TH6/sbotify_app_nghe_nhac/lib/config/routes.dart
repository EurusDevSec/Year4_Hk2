import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/playlist/playlist_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';

class Routes {
  static const String home = '/';
  static const String player = '/player';
  static const String playlist = '/playlist';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      player: (context) => const PlayerScreen(),
      playlist: (context) => const PlaylistScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
    };
  }
}

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String player = '/player';
  static const String playlist = '/playlist';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
}
