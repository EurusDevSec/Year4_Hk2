class AppConstants {
  // API Endpoints
  static const String songListEndpoint = '/songs';
  static const String searchEndpoint = '/songs/search';
  static const String userEndpoint = '/users';

  // Durations
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  // Error Messages
  static const String defaultErrorMessage = 'Có lỗi xảy ra. Vui lòng thử lại.';
  static const String networkErrorMessage =
      'Không thể kết nối. Vui lòng kiểm tra kết nối mạng.';
  static const String authErrorMessage =
      'Lỗi xác thực. Vui lòng đăng nhập lại.';

  // Success Messages
  static const String addedToFavoritesMessage = 'Đã thêm vào yêu thích';
  static const String removedFromFavoritesMessage = 'Đã xóa khỏi yêu thích';
}
