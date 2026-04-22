import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/news_repository.dart';
import 'data/services/settings_service.dart';
import 'ui/screens/main_screen.dart';
import 'ui/viewmodels/news_list_viewmodel.dart';
import 'ui/viewmodels/settings_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsService = SettingsService();
  await settingsService.init();
  runApp(MyApp(settingsService: settingsService));
}

class MyApp extends StatelessWidget {
  final SettingsService settingsService;

  const MyApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    final newsRepository = NewsRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsListViewModel(repository: newsRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(settingsService: settingsService),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVM, _) {
          final isDarkMode = settingsVM.settings.isDarkMode;

          return MaterialApp(
            title: 'ĐỌC BÁO ONLINE',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
