# Hướng dẫn Firebase & Firestore

## Thiết lập Firebase

### 1. Tạo Firestore Database

- Collection: `users`
- Document fields:
  - `name` (string)
  - `email` (string)
  - `age` (number)

### 2. Cài đặt Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 3. Package Dependencies

```yaml
dependencies:
  firebase_core: ^latest
  cloud_firestore: ^latest
  firebase_auth: ^latest # nếu cần auth
```

## Khởi tạo Firebase

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

## Best Practices

### Connection Management

- Khởi tạo Firebase một lần ở main()
- Sử dụng singleton pattern cho Firestore instance
- Xử lý connection errors

### Data Operations

- Luôn validate dữ liệu trước khi gửi
- Sử dụng transactions cho multi-document updates
- Implement retry logic cho failed operations

### Performance

- Sử dụng indexes cho complex queries
- Paginate large datasets
- Cache data khi có thể

### Security

- Khi production, bật authentication
- Dùng Firebase Security Rules
- Không expose sensitive data ở client

## Quy tắc Naming

- Collection name: lowercase, plural (users)
- Document ID: Firebase auto-generates hoặc meaningful ID
- Field name: camelCase
- Timestamps: use Timestamp.now()

## Error Handling

```dart
try {
  // Firestore operation
} on FirebaseException catch (e) {
  print('Firebase Error: ${e.code} - ${e.message}');
  // Handle specific error codes
} catch (e) {
  print('Unknown Error: $e');
}
```

## Firestore Queries

### Get all users (Stream)

```dart
FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .listen((snapshot) {
      final users = snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    });
```

### Get single user

```dart
final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .get();
```

### Add user

```dart
await FirebaseFirestore.instance
    .collection('users')
    .add({'name': 'John', 'email': 'john@example.com', 'age': 25});
```

### Update user

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .update({'name': 'Jane'});
```

### Delete user

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .delete();
```

## Testing Firestore

- Dùng Firebase Emulator Suite cho local testing
- Mock Firestore cho unit tests
- Kiểm tra security rules trước deploy
