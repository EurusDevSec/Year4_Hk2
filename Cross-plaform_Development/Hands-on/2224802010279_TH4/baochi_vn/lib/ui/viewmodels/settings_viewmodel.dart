import 'package:flutter/foundation.dart';
import '../../data/models/app_settings.dart';
import '../../data/services/settings_service.dart';

/// ViewModel for managing app settings
class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService;

  AppSettings _settings = const AppSettings();
  bool _isLoading = false;
  String? _error;

  // Getters
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  SettingsViewModel({required SettingsService settingsService})
    : _settingsService = settingsService {
    _loadSettings();
  }

  /// Load settings from storage
  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _settings = await _settingsService.getSettings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update theme
  Future<void> setTheme(bool isDarkMode) async {
    _settings = _settings.copyWith(isDarkMode: isDarkMode);
    notifyListeners();

    try {
      await _settingsService.setTheme(isDarkMode);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update student information
  Future<void> updateStudentInfo({
    String? studentId,
    String? studentName,
    String? studentClass,
  }) async {
    _settings = _settings.copyWith(
      studentId: studentId,
      studentName: studentName,
      studentClass: studentClass,
    );
    notifyListeners();

    try {
      await _settingsService.setStudentInfo(
        studentId: studentId,
        studentName: studentName,
        studentClass: studentClass,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Reload settings
  Future<void> reloadSettings() async {
    await _loadSettings();
  }
}
