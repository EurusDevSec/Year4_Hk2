# Hướng Dẫn Sử Dụng Ứng Dụng Ghi Chú Cá Nhân

## Tổng Quan Ứng Dụng

Ứng dụng **Note App** là một ứng dụng ghi chú cá nhân đầy đủ được xây dựng bằng Flutter. Ứng dụng cho phép người dùng:

- ✅ Tạo ghi chú mới
- ✅ Xem danh sách ghi chú
- ✅ Chỉnh sửa ghi chú hiện có
- ✅ Xóa ghi chú
- ✅ Lưu trữ dữ liệu cục bộ với SharedPreferences

## Yêu Cầu Dự Án Hoàn Thành

### 1. **Màn hình Chính** ✅

- Hiển thị danh sách tất cả ghi chú
- Mỗi ghi chú hiển thị:
  - 📌 Tiêu đề (in đậm, nổi bật)
  - 📝 Nội dung ngắn (50 ký tự đầu tiên)
  - 🕐 Thời gian tạo (định dạng: DD/MM/YYYY HH:MM)
- 🔘 Nút thêm ghi chú (+) ở góc dưới bên phải
- 📭 Hiển thị thông báo khi không có ghi chú

### 2. **Thêm Ghi Chú** ✅

- Nhấn nút + để mở màn hình thêm ghi chú
- Nhập:
  - 📋 Tiêu đề ghi chú
  - 📄 Nội dung ghi chú (đa dòng)
- Kiểm tra hợp lệ (tiêu đề và nội dung không được trống)
- Nhấn nút "Save" để lưu
- Quay về màn hình chính tự động

### 3. **Chỉnh Sửa Ghi Chú** ✅

- Nhấn vào ghi chú trong danh sách
- Mở màn hình chỉnh sửa với dữ liệu cũ
- Sửa đổi tiêu đề/nội dung
- Nhấn "Save" để cập nhật
- Danh sách tự động cập nhật

### 4. **Xóa Ghi Chú** ✅

Có 2 cách để xóa ghi chú:

**Cách 1: Giữ lâu trên ghi chú (Long Press)**

- Giữ lâu trên một ghi chú
- Chọn "Delete Note"
- Xác nhận xóa trong hộp thoại

**Cách 2: Dùng Menu Popup**

- Nhấn nút menu (⋮) ở phía bên phải ghi chú
- Chọn "Delete"
- Xác nhận trong hộp thoại

### 5. **Lưu Trữ Dữ Liệu** ✅

- 💾 Sử dụng **SharedPreferences** (lưu trữ cục bộ)
- 📦 Dữ liệu được lưu dưới dạng JSON
- 🔄 Dữ liệu vẫn còn sau khi tắt ứng dụng
- 📊 Danh sách sắp xếp theo ngày tạo (mới nhất đầu)

## Cấu Trúc Dự Án

```
lib/
├── main.dart                    # Điểm khởi tạo ứng dụng
├── models/
│   └── note.dart                # Model dữ liệu Note
├── services/
│   └── note_service.dart        # Xử lý lưu trữ và logic
└── screens/
    ├── home_screen.dart         # Màn hình danh sách ghi chú
    └── note_screen.dart         # Màn hình thêm/sửa ghi chú
```

## Các Thư Viện Sử Dụng

```yaml
dependencies:
  flutter: ^3.9.2
  shared_preferences: ^2.2.2 # Lưu trữ dữ liệu cục bộ
  intl: ^0.19.0 # Định dạng ngày tháng
  cupertino_icons: ^1.0.8 # Icon
```

## Cách Chạy Ứng Dụng

### 1. **Cài Đặt Dependencies**

```bash
flutter pub get
```

### 2. **Chạy Ứng Dụng**

```bash
flutter run
```

### 3. **Build Release**

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Hướng Dẫn Chi Tiết

### Tạo Ghi Chú Mới

1. Nhấn nút **+** ở góc dưới bên phải
2. Nhập **Tiêu đề** ghi chú
3. Nhập **Nội dung** ghi chú
4. Nhấn nút **Save** ở trên cùng
5. Ghi chú sẽ xuất hiện trong danh sách

### Chỉnh Sửa Ghi Chú

1. **Tap vào ghi chú** trong danh sách
2. Sửa **tiêu đề** hoặc **nội dung**
3. Nhấn **Save**
4. Thay đổi được cập nhật tự động

### Xóa Ghi Chú

**Phương Pháp 1 - Long Press:**

1. **Giữ lâu** trên ghi chú
2. Chọn "Delete Note"
3. Xác nhận xóa

**Phương Pháp 2 - Popup Menu:**

1. Nhấn **nút menu** (⋮) bên phải
2. Chọn "Delete"
3. Xác nhận xóa

## Định Dạng Dữ Liệu

Ghi chú được lưu trữ với thông tin:

```json
{
  "id": "1715000000000",
  "title": "Tiêu đề ghi chú",
  "content": "Nội dung chi tiết của ghi chú",
  "createdAt": "2026-05-05T14:30:00.000Z",
  "updatedAt": "2026-05-05T15:00:00.000Z"
}
```

## Giao Diện Người Dùng

- 🎨 Material Design 3
- 💙 Màu chủ đạo: Xanh da trời
- 📱 Thiết kế responsive cho tất cả kích thước màn hình
- ♿ Hỗ trợ accessibility

## Tính Năng Bổ Sung

✨ **Thông Báo Thành Công/Lỗi**

- Hiển thị thông báo Snackbar khi:
  - Lưu ghi chú thành công
  - Xóa ghi chú thành công
  - Có lỗi xảy ra

## Kiểm Tra Mã Code

Để kiểm tra mã không có lỗi:

```bash
flutter analyze
```

Để định dạng mã tự động:

```bash
flutter format lib/
```

## Khắc Phục Sự Cố

### Vấn đề: Ứng dụng không khởi động

- Chạy: `flutter pub get`
- Chạy: `flutter clean`
- Chạy lại: `flutter run`

### Vấn đề: Ghi chú không hiển thị

- Kiểm tra xem SharedPreferences đã được khởi tạo
- Xóa app và cài đặt lại

### Vấn đề: Lỗi build

- Cập nhật Flutter: `flutter upgrade`
- Xóa build folder: `flutter clean`
- Cài đặt lại dependencies: `flutter pub get`

## Thông Tin Dự Án

- **Ngôn Ngữ**: Dart/Flutter
- **Phiên Bản Flutter**: 3.9.2+
- **Nền Tảng**: Android, iOS, Web, Windows, macOS, Linux
- **Lưu Trữ**: SharedPreferences (Local JSON)
- **Ngày Tạo**: Tháng 5 năm 2026

---

**Ứng dụng đã hoàn thành tất cả các yêu cầu!** 🎉

Nếu có bất kỳ câu hỏi nào, hãy kiểm tra file `APP_DOCUMENTATION.md` để biết thêm chi tiết kỹ thuật.
