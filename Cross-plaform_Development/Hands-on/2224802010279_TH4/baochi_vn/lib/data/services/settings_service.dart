import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Service for managing app settings using SharedPreferences
class SettingsService {
  static const String _settingsKey = 'app_settings';
  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize the service
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  /// Get current app settings
  Future<AppSettings> getSettings() async {
    await init();
    final jsonString = _prefs.getString(_settingsKey);

    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return AppSettings.fromJson(json);
      } catch (e) {
        return const AppSettings();
      }
    }
    return const AppSettings();
  }

  /// Save app settings
  Future<void> saveSettings(AppSettings settings) async {
    await init();
    final jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(_settingsKey, jsonString);
  }

  /// Update theme setting
  Future<void> setTheme(bool isDarkMode) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(isDarkMode: isDarkMode));
  }

  /// Update student information
  Future<void> setStudentInfo({
    String? studentId,
    String? studentName,
    String? studentClass,
  }) async {
    final settings = await getSettings();
    await saveSettings(
      settings.copyWith(
        studentId: studentId,
        studentName: studentName,
        studentClass: studentClass,
      ),
    );
  }

  /// Clear all settings
  Future<void> clearSettings() async {
    await init();
    await _prefs.remove(_settingsKey);
  }
}
