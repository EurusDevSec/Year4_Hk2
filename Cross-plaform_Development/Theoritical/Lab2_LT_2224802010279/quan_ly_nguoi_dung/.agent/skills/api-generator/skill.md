# Skill: API Code Generator

## Mục tiêu

Tự động sinh code để tương tác với Firestore collection.

## Chức năng

### 1. Generate Service Class

Dùng để tạo CRUD service từ model definition.

```dart
// Input
class User {
  final String id;
  final String name;
  final String email;
  final int age;
}

// Output: FirestoreService được tự động sinh với:
// - addUser(User)
// - getUser(String)
// - getUsersStream()
// - updateUser(String, User)
// - deleteUser(String)
```

### 2. Generate Provider

Tự động sinh Riverpod provider cho state management.

```dart
// Output
final firestoreServiceProvider = Provider((ref) => FirestoreService());

final usersStreamProvider = StreamProvider<List<User>>((ref) {
  return ref.watch(firestoreServiceProvider).getUsersStream();
});

final userProvider = FutureProvider.family<User, String>((ref, id) {
  return ref.watch(firestoreServiceProvider).getUser(id);
});
```

### 3. Generate Validators

Tự động sinh validation rules từ field constraints.

```dart
class UserValidators {
  static String? validateName(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter name';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter email';
    if (!value!.contains('@')) return 'Invalid email';
    return null;
  }

  static String? validateAge(String? value) {
    if (value?.isEmpty ?? true) return 'Please enter age';
    final age = int.tryParse(value!);
    if (age == null || age < 0 || age > 150) return 'Invalid age';
    return null;
  }
}
```

## Configuration

Create `codegen_config.yaml`:

```yaml
model:
  name: User
  collection: users
  fields:
    - name: name
      type: String
      required: true
    - name: email
      type: String
      required: true
      validator: email
    - name: age
      type: int
      required: true
      validator: age

generate:
  service: true
  provider: true
  validators: true
  widgets: false
```

## Usage

```bash
# Generate code
dart run build_runner build

# Watch for changes
dart run build_runner watch
```

## Output Structure

```
lib/generated/
├── firestore_service.g.dart
├── providers.g.dart
└── validators.g.dart
```

## Benefits

- Reduce boilerplate code
- Consistency across project
- Faster development
- Automatic validation
- Type-safe operations

## Advanced Features

1. **Generate UI Forms** - Tự động tạo form từ model
2. **Generate Tests** - CRUD test templates
3. **Generate Documentation** - API docs
4. **Database Migrations** - Detect schema changes
