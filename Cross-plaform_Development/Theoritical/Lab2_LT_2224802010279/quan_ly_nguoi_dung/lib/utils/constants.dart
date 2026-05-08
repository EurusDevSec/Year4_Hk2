class AppConstants {
  // Firestore
  static const String usersCollection = 'users';

  // Validation
  static const int minAge = 0;
  static const int maxAge = 150;

  // Messages
  static const String userAddedSuccess = 'User added successfully';
  static const String userUpdatedSuccess = 'User updated successfully';
  static const String userDeletedSuccess = 'User deleted successfully';
  static const String noUsersFound = 'No users found. Tap + to add new user.';

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String loadingError = 'Failed to load users.';
}
