import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_list_viewmodel.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'latest_screen.dart';
import 'settings_screen.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const LatestScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsListViewModel>().loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Chủ đề'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Mới nhất',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}
