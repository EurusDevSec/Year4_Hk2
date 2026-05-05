# Sbotify - Cấu Trúc Dự Án

## 📁 Cấu Trúc Thư Mục

```
lib/
├── main.dart                 # Entry point của ứng dụng
├── config/                   # Cấu hình ứng dụng
│   ├── app_config.dart      # Cấu hình chung (API, Firebase, feature flags)
│   ├── theme.dart           # Định nghĩa theme và màu sắc
│   └── routes.dart          # Định tuyến ứng dụng
├── models/                   # Data models
│   ├── song.dart            # Model bài hát
│   ├── playlist.dart        # Model danh sách phát
│   └── user.dart            # Model người dùng
├── services/                 # Các service và logic nghiệp vụ
│   ├── audio_service.dart   # Quản lý phát nhạc (JustAudio)
│   ├── api_service.dart     # Gọi API bên ngoài
│   ├── auth_service.dart    # Xác thực (Firebase Auth)
│   └── firebase_service.dart# Firebase Firestore & Storage
├── providers/                # State management (Provider)
│   ├── auth_provider.dart   # Quản lý trạng thái xác thực
│   ├── audio_provider.dart  # Quản lý trạng thái phát nhạc
│   └── playlist_provider.dart # Quản lý danh sách phát
├── screens/                  # Các màn hình
│   ├── home/
│   │   └── home_screen.dart # Màn hình danh sách bài hát
│   ├── player/
│   │   └── player_screen.dart # Màn hình phát nhạc
│   ├── playlist/
│   │   └── playlist_screen.dart # Màn hình quản lý danh sách phát
│   └── auth/
│       └── login_screen.dart # Màn hình đăng nhập
├── widgets/                  # Các widget tái sử dụng
│   ├── song_card.dart       # Thẻ bài hát
│   ├── player_controls.dart # Nút điều khiển phát nhạc
│   ├── search_bar.dart      # Thanh tìm kiếm
│   └── progress_slider.dart # Thanh progress
└── utils/                    # Utilities
    └── constants.dart       # Hằng số chung
```

## 🏗️ Kiến Trúc

### Models Layer

- Định nghĩa các data class: `Song`, `Playlist`, `User`
- Hỗ trợ JSON serialization/deserialization

### Services Layer

- **AudioService**: Quản lý phát nhạc với JustAudio
- **ApiService**: Gọi API lấy danh sách bài hát
- **AuthService**: Firebase Authentication
- **FirebaseService**: Firestore & Storage operations

### Providers Layer (State Management)

- **AuthProvider**: Quản lý trạng thái đăng nhập
- **AudioProvider**: Quản lý trạng thái phát nhạc (playlist, position, duration)
- **PlaylistProvider**: Quản lý danh sách bài hát & danh sách phát

### Screens & Widgets

- **HomeScreen**: Hiển thị danh sách bài hát + thanh tìm kiếm
- **PlayerScreen**: Hiển thị thông tin bài hát đang phát
- **PlaylistScreen**: Quản lý danh sách phát cá nhân
- **LoginScreen**: Đăng nhập/Đăng ký
- Reusable Widgets: `SongCard`, `PlayerControls`, `SearchBar`, `ProgressSlider`

## 🔧 Dependencies

```yaml
provider: ^6.0.0 # State management
just_audio: ^0.9.34 # Audio player
http: ^1.1.0 # HTTP requests
firebase_core: ^2.24.0 # Firebase
cloud_firestore: ^4.13.0 # Firestore
firebase_auth: ^4.16.0 # Firebase Auth
cached_network_image: ^3.3.0 # Image caching
google_fonts: ^6.1.0 # Google Fonts
```

## 🚀 Cách Sử Dụng

### Thêm Bài Hát Mới

1. Tạo instance `Song` với dữ liệu
2. Thêm vào `PlaylistProvider.allSongs`
3. Cập nhật Firebase nếu cần

### Phát Nhạc

1. Chọn bài hát từ `HomeScreen`
2. `AudioProvider.playSong()` sẽ được gọi
3. Chuyển đến `PlayerScreen`
4. Sử dụng `PlayerControls` để điều khiển

### Đăng Nhập

1. Nhập email và mật khẩu
2. `AuthProvider.login()` xác thực qua Firebase
3. Nếu thành công, chuyển đến `HomeScreen`

### Quản Lý Danh Sách Phát

1. Vào `PlaylistScreen`
2. Nhấn nút "+" để tạo danh sách phát mới
3. Thêm bài hát vào danh sách phát
4. Lưu vào Firebase

## 📝 Hướng Dẫn Phát Triển

### Thêm Feature Mới

1. Tạo file model nếu cần dữ liệu mới
2. Tạo service để xử lý logic
3. Tạo provider cho state management
4. Tạo screen/widget hiển thị
5. Cập nhật routes trong `config/routes.dart`

### Best Practices

- Tách logic khỏi UI (services & providers)
- Sử dụng provider cho state management
- Tạo reusable widgets
- Thêm error handling
- Sử dụng constants từ `utils/constants.dart`

## 🔐 Firebase Setup

1. Tạo Firebase project
2. Kích hoạt Authentication (Email/Password)
3. Tạo Firestore database
4. Tạo Storage bucket
5. Download `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)

## 📚 Tài Liệu Tham Khảo

- [Provider Documentation](https://pub.dev/packages/provider)
- [JustAudio Documentation](https://pub.dev/packages/just_audio)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
