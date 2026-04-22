/// Model for storing app settings
class AppSettings {
  final bool isDarkMode;
  final String? studentId;
  final String? studentName;
  final String? studentClass;

  const AppSettings({
    this.isDarkMode = false,
    this.studentId,
    this.studentName,
    this.studentClass,
  });

  /// Convert AppSettings to JSON map
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
    };
  }

  /// Create AppSettings from JSON map
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      studentClass: json['studentClass'] as String?,
    );
  }

  /// Create a copy with modified fields
  AppSettings copyWith({
    bool? isDarkMode,
    String? studentId,
    String? studentName,
    String? studentClass,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentClass: studentClass ?? this.studentClass,
    );
  }
}
