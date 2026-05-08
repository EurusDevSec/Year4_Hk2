# Hướng dẫn Testing

## Unit Tests

### Test Firebase Service

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference {}
class MockDocumentReference extends Mock implements DocumentReference {}

void main() {
  group('FirestoreService Tests', () {
    late FirestoreService firestoreService;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      firestoreService = FirestoreService();
    });

    test('addUser should return document ID', () async {
      // Arrange
      final user = User(
        id: '',
        name: 'John Doe',
        email: 'john@example.com',
        age: 25,
      );

      // Act & Assert
      // Implementation depends on how you structure Firestore service
    });

    test('getUsersStream should return list of users', () async {
      // Test implementation
    });

    test('deleteUser should remove user from Firestore', () async {
      // Test implementation
    });
  });
}
```

### Test Model

```dart
test('User.fromFirestore should convert document to user', () {
  // Arrange
  final mockDoc = {
    'name': 'Jane Doe',
    'email': 'jane@example.com',
    'age': 30,
  };

  // Act
  // final user = User.fromFirestore(mockDoc);

  // Assert
  // expect(user.name, 'Jane Doe');
  // expect(user.email, 'jane@example.com');
  // expect(user.age, 30);
});

test('User.toMap should convert user to map', () {
  // Arrange
  final user = User(
    id: '1',
    name: 'John',
    email: 'john@example.com',
    age: 25,
  );

  // Act
  final map = user.toMap();

  // Assert
  expect(map['name'], 'John');
  expect(map['email'], 'john@example.com');
  expect(map['age'], 25);
});
```

## Widget Tests

### Test Form Widget

```dart
testWidgets('UserForm displays all fields', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: UserForm(
          onSubmit: (user) {},
        ),
      ),
    ),
  );

  expect(find.byType(TextField), findsWidgets);
  expect(find.byType(ElevatedButton), findsOneWidget);
});

testWidgets('UserForm validates empty name', (WidgetTester tester) async {
  final formKey = GlobalKey<FormState>();

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: UserForm(
            onSubmit: (user) {},
          ),
        ),
      ),
    ),
  );

  // Tap submit without entering name
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  expect(find.text('Please enter name'), findsOneWidget);
});
```

### Test List Screen

```dart
testWidgets('UserListScreen displays user list', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: HomeScreen(),
    ),
  );

  // Wait for data to load
  await tester.pumpAndSettle();

  // Verify list is displayed
  expect(find.byType(ListView), findsOneWidget);
});
```

## Integration Tests

### Test CRUD Flow

```dart
void main() {
  group('User CRUD Integration Test', () {
    late FirestoreService firestoreService;

    setUp(() {
      firestoreService = FirestoreService();
    });

    test('Complete CRUD flow', () async {
      // Create
      final user = User(
        id: '',
        name: 'Test User',
        email: 'test@example.com',
        age: 25,
      );
      final userId = await firestoreService.addUser(user);
      expect(userId, isNotEmpty);

      // Read
      final readUser = await firestoreService.getUserById(userId);
      expect(readUser?.name, 'Test User');

      // Update
      final updatedUser = user.copyWith(id: userId, name: 'Updated User');
      await firestoreService.updateUser(userId, updatedUser);

      // Verify update
      final verifyUser = await firestoreService.getUserById(userId);
      expect(verifyUser?.name, 'Updated User');

      // Delete
      await firestoreService.deleteUser(userId);

      // Verify delete
      final deletedUser = await firestoreService.getUserById(userId);
      expect(deletedUser, isNull);
    });
  });
}
```

## Test Utilities

### Mock Data

```dart
class MockUserData {
  static final users = [
    User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      age: 25,
    ),
    User(
      id: '2',
      name: 'Jane Smith',
      email: 'jane@example.com',
      age: 30,
    ),
  ];
}
```

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/user_model_test.dart

# Run with coverage
flutter test --coverage

# Run widget tests only
flutter test --grep "testWidgets"

# Run unit tests only
flutter test --grep "test\\("
```

## Test Coverage Goals

- **Models**: 100% coverage
- **Services**: 90%+ coverage
- **Widgets**: 80%+ coverage
- **Overall**: 85%+ coverage

## Best Practices

1. **Arrange-Act-Assert** - Cấu trúc test thành 3 phần rõ ràng
2. **Test behavior, not implementation** - Kiểm tra kết quả, không cách làm
3. **Mock external dependencies** - Firebase, services
4. **Use factories** - Để tạo test data
5. **Test error cases** - Không chỉ happy path
6. **Keep tests independent** - Không phụ thuộc vào test khác
7. **Use meaningful names** - Tên test phải mô tả rõ ý định
