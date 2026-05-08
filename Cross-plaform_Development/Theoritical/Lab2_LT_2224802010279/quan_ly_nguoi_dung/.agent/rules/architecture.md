# Kiến trúc Ứng dụng

## Cấu trúc Thư mục

```
lib/
├── main.dart                    # Entry point
├── models/
│   └── user_model.dart          # Model User (id, name, email, age)
├── services/
│   ├── firebase_service.dart    # Service Firebase
│   └── firestore_service.dart   # Service Firestore CRUD
├── providers/                   # State management (Provider/Riverpod)
│   ├── user_provider.dart
│   ├── loading_provider.dart
│   └── error_provider.dart
├── screens/
│   ├── home_screen.dart         # Màn hình chính - danh sách user
│   ├── add_user_screen.dart     # Màn hình thêm user
│   └── edit_user_screen.dart    # Màn hình chỉnh sửa user
├── widgets/
│   ├── user_list_item.dart      # Widget item trong danh sách
│   ├── user_form.dart           # Widget form (dùng chung thêm/sửa)
│   ├── loading_widget.dart      # Widget loading
│   └── error_widget.dart        # Widget hiển thị lỗi
└── utils/
    ├── constants.dart           # Hằng số
    └── validators.dart          # Validators cho form
```

## Cấu trúc Model

```dart
class User {
  final String id;
  final String name;
  final String email;
  final int age;

  User({required this.id, required this.name, required this.email, required this.age});

  // Factory constructor từ Firestore
  // toMap() để convert sang map
  // copyWith() để tạo bản sao
}
```

## State Management (Provider)

```dart
// User list provider (StreamProvider)
final userStreamProvider = StreamProvider<List<User>>((ref) {
  // Return stream từ Firestore
});

// Loading state provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error state provider
final errorMessageProvider = StateProvider<String?>((ref) => null);
```

## Layer tương tác Firebase

```
FirebaseService (Initialization)
    ↓
FirestoreService (CRUD operations)
    ↓
Provider (State Management)
    ↓
UI Widgets (StreamBuilder/Consumer)
```

## Quy tắc Code

1. **Separation of Concerns**: Tách biệt logic Firebase, state management, và UI
2. **Error Handling**: Mọi operation phải có try-catch
3. **Async Operations**: Sử dụng async/await hoặc streams
4. **Loading States**: Hiển thị loading indicator cho mọi operation
5. **Real-time Updates**: Dùng StreamBuilder/Consumer với stream từ Firestore

## Luồng Dữ liệu

```
User Input (Form)
    ↓
Validate Input
    ↓
Call FirestoreService
    ↓
Update Firestore
    ↓
Update Provider (state change)
    ↓
UI Auto-refresh via StreamBuilder
    ↓
Show Success Message
```
