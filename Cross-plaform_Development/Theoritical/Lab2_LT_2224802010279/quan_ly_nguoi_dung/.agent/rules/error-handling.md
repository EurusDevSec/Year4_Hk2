# Xử lý Lỗi

## Chiến lược Xử lý Lỗi Toàn cục

### 1. Kiểu Lỗi Chính

- **Network Errors**: Không có internet, timeout
- **Firebase Errors**: Authentication, Firestore operations
- **Validation Errors**: Dữ liệu không hợp lệ
- **Unknown Errors**: Lỗi không xác định

### 2. Try-Catch Pattern

```dart
try {
  // Operation
} on FirebaseException catch (e) {
  _handleFirebaseError(e);
} on SocketException catch (e) {
  _handleNetworkError(e);
} catch (e) {
  _handleUnknownError(e);
} finally {
  // Cleanup nếu cần
}
```

## Firebase Error Handling

```dart
void _handleFirebaseError(FirebaseException e) {
  String message = 'An error occurred';

  switch (e.code) {
    case 'permission-denied':
      message = 'Permission denied';
      break;
    case 'not-found':
      message = 'Document not found';
      break;
    case 'unavailable':
      message = 'Service unavailable';
      break;
    default:
      message = e.message ?? 'Firebase error';
  }

  _showErrorSnackBar(message);
  _logError('Firebase Error: ${e.code} - ${e.message}');
}
```

## Network Error Handling

```dart
void _handleNetworkError(SocketException e) {
  String message = 'Network error. Please check your connection.';
  _showErrorSnackBar(message);
  _logError('Network Error: $e');
}
```

## Validation Error Handling

```dart
String? validateEmail(String? value) {
  if (value?.isEmpty ?? true) {
    return 'Email is required';
  }
  if (!value!.contains('@')) {
    return 'Invalid email format';
  }
  return null;
}

String? validateAge(String? value) {
  if (value?.isEmpty ?? true) {
    return 'Age is required';
  }
  final age = int.tryParse(value!);
  if (age == null || age < 0 || age > 150) {
    return 'Please enter valid age';
  }
  return null;
}
```

## UI Error Display

### SnackBar

```dart
void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}
```

### Dialog

```dart
void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
```

## Logging Errors

```dart
void _logError(String message, [dynamic error, StackTrace? stackTrace]) {
  print('❌ ERROR: $message');
  if (error != null) print('Details: $error');
  if (stackTrace != null) print('Stack: $stackTrace');

  // Có thể gửi error report tới remote logging service
}
```

## Error Recovery

### Retry Logic

```dart
Future<T> retryOperation<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  while (attempts < maxRetries) {
    try {
      return await operation();
    } catch (e) {
      attempts++;
      if (attempts >= maxRetries) rethrow;
      await Future.delayed(delay);
      _logError('Retrying operation... (attempt $attempts)');
    }
  }
  throw Exception('Max retries exceeded');
}
```

### Usage

```dart
await retryOperation(
  () => firestoreService.addUser(user),
  maxRetries: 3,
);
```

## Error State Management

```dart
class ErrorState {
  final String message;
  final String code;
  final DateTime timestamp;

  ErrorState({
    required this.message,
    required this.code,
    required this.timestamp,
  });
}
```

## Best Practices

1. **Always catch errors** - Mỗi async operation cần try-catch
2. **Log errors** - Ghi log tất cả lỗi cho debugging
3. **Show user-friendly messages** - Không show technical errors cho user
4. **Provide recovery options** - Cho user cơ hội retry
5. **Clear error state** - Xóa lỗi cũ sau khi fixed
6. **Test error scenarios** - Kiểm tra xử lý lỗi trong tests
