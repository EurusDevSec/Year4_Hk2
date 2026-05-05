# 🎵 Sbotify - Ứng Dụng Nghe Nhạc Online

Một ứng dụng Flutter để nghe nhạc online với giao diện hiện đại, hỗ trợ danh sách phát, yêu thích và đăng nhập.

## ✨ Tính Năng

- ✅ **Danh sách bài hát**: Hiển thị danh sách bài hát với ảnh thumbnail
- ✅ **Tìm kiếm**: Tìm kiếm bài hát theo tên hoặc nghệ sĩ
- ✅ **Phát nhạc**: Stream nhạc online từ URL (không cần tải về)
- ✅ **Điều khiển**: Play/Pause, Next, Previous, Seek
- ✅ **Danh sách phát**: Tạo và quản lý danh sách phát cá nhân
- ✅ **Yêu thích**: Đánh dấu bài hát yêu thích
- ✅ **Đăng nhập**: Xác thực qua Firebase
- ✅ **Lưu trữ**: Lưu playlist và yêu thích trên Firebase

## 📋 Yêu Cầu

- Flutter 3.9+
- Dart 3.9+
- Firebase project
- API endpoint hoặc danh sách MP3 URL

## 🚀 Cài Đặt

### 1. Clone Project

```bash
git clone <repo-url>
cd sbotify_app_nghe_nhac
```

### 2. Cài Đặt Dependencies

```bash
flutter pub get
```

### 3. Setup Firebase

#### Android

1. Tạo Firebase project tại [Firebase Console](https://console.firebase.google.com)
2. Thêm ứng dụng Android
3. Download `google-services.json` và đặt vào `android/app/`
4. Cập nhật `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

5. Cập nhật `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

#### iOS

1. Download `GoogleService-Info.plist` từ Firebase Console
2. Đặt vào `ios/Runner/`
3. Thêm vào Xcode: Right-click `Runner` → Add Files → Chọn file
4. Chọn target `Runner` và đảm bảo file được thêm

#### Web (optional)

```dart
// Trong main.dart, thêm Firebase initialization
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 4. Cấu Hình API

**Option A: Sử dụng API Public**

- Cập nhật `lib/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'https://your-api.com';
```

**Option B: Sử dụng Firebase**

- Cấu hình Firestore collection `songs` với fields:
  - `id`: String
  - `title`: String
  - `artist`: String
  - `imageUrl`: String
  - `audioUrl`: String
  - `duration`: Number

### 5. Chạy Ứng Dụng

```bash
# Development
flutter run

# Release
flutter run --release
```

## 📁 Cấu Trúc Dự Án

Xem [ARCHITECTURE.md](ARCHITECTURE.md) để hiểu chi tiết về cấu trúc thư mục và kiến trúc ứng dụng.

```
lib/
├── config/          # Cấu hình (theme, routes)
├── models/          # Data models (Song, Playlist, User)
├── services/        # Logic nghiệp vụ
├── providers/       # State management (Provider)
├── screens/         # Các màn hình
├── widgets/         # Widgets tái sử dụng
└── utils/           # Utilities
```

## 🎯 Các Màn Hình

### 1. **Home Screen** (Danh sách bài hát)

- Hiển thị danh sách bài hát
- Thanh tìm kiếm
- Nhấn để phát bài hát

### 2. **Player Screen** (Phát nhạc)

- Hiển thị ảnh bài hát
- Tên bài hát & nghệ sĩ
- Thanh progress
- Nút: Play/Pause, Next, Previous

### 3. **Playlist Screen** (Quản lý danh sách phát)

- Hiển thị danh sách phát của người dùng
- Tạo danh sách phát mới
- Thêm/xóa bài hát

### 4. **Login Screen** (Đăng nhập)

- Nhập email & mật khẩu
- Đăng nhập hoặc Đăng ký
- Kết nối với Firebase

## 🔧 Cách Sử Dụng Các Provider

### AuthProvider

```dart
// Đăng nhập
context.read<AuthProvider>().login(email, password);

// Đăng ký
context.read<AuthProvider>().signUp(email, password, displayName);

// Đăng xuất
context.read<AuthProvider>().logout();

// Kiểm tra đăng nhập
bool isAuth = context.read<AuthProvider>().isAuthenticated;
```

### AudioProvider

```dart
// Load danh sách phát
context.read<AudioProvider>().loadPlaylist(songs);

// Phát bài hát
context.read<AudioProvider>().playSong(0);

// Tạm dừng/Tiếp tục
context.read<AudioProvider>().togglePlayPause();

// Bài tiếp theo/Bài trước
context.read<AudioProvider>().nextSong();
context.read<AudioProvider>().previousSong();

// Tìm kiếm
context.read<AudioProvider>().seek(duration);
```

### PlaylistProvider

```dart
// Lấy danh sách bài hát
context.read<PlaylistProvider>().fetchSongs();

// Tìm kiếm
context.read<PlaylistProvider>().searchSongs(query);

// Tạo danh sách phát
context.read<PlaylistProvider>().createPlaylist(name, description, userId);
```

## 🎨 Tùy Chỉnh Giao Diện

### Đổi Màu Chủ Đề

Cập nhật `lib/config/theme.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.yourColor, // Thay đổi màu
  brightness: Brightness.light,
),
```

### Đổi Font

Sử dụng Google Fonts (đã được cập nhật):

```dart
textTheme: GoogleFonts.poppinsTextTheme(), // Hoặc font khác
```

## 🐛 Gỡ Lỗi

### Lỗi: "audio_session" không tìm được

```bash
flutter pub get
flutter clean
flutter pub get
```

### Lỗi: Firebase không khởi tạo

- Kiểm tra `google-services.json` hoặc `GoogleService-Info.plist`
- Đảm bảo Firebase project ID khớp

### Lỗi: Không phát nhạc

- Kiểm tra URL MP3 có hợp lệ
- Kiểm tra kết nối internet
- Xem logs: `flutter logs`

## 📚 Tài Liệu

- [Flutter Docs](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [JustAudio Package](https://pub.dev/packages/just_audio)
- [Firebase Docs](https://firebase.google.com/docs)

## 💡 Gợi Ý Phát Triển

1. **Offline Mode**: Lưu cache bài hát
2. **Themes**: Hỗ trợ theme tối
3. **Social**: Chia sẻ playlist
4. **Recommendation**: Gợi ý bài hát
5. **Queue**: Quản lý hàng chờ
6. **Visualization**: Hiệu ứng âm thanh

## 📞 Hỗ Trợ

Nếu gặp vấn đề, vui lòng:

1. Kiểm tra [ARCHITECTURE.md](ARCHITECTURE.md)
2. Xem logs
3. Tạo issue trên GitHub

## 📄 License

MIT License - Tự do sử dụng cho mục đích cá nhân và học tập.

---

**Made with ❤️ for music lovers** 🎵
