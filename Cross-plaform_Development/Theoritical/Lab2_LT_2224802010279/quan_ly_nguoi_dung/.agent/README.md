# Hướng dẫn .Agent - Quản lý Người dùng Flutter App

## Tổng quan

Dự án là một ứng dụng Flutter quản lý người dùng sử dụng Firebase Firestore làm backend.

## Cấu trúc .agent

```
.agent/
├── config.json                 # Cấu hình dự án
├── README.md                   # File này
├── rules/                      # Quy tắc mã hóa và kiến trúc
│   ├── architecture.md         # Cấu trúc ứng dụng
│   ├── boilerplate.md          # Mẫu code
│   ├── testing.md              # Hướng dẫn test
│   ├── firebase-guidelines.md  # Quy tắc Firebase
│   └── error-handling.md       # Xử lý lỗi
├── workflows/                  # Các workflow chính
│   ├── list-users.md           # Workflow hiển thị danh sách
│   ├── add-user.md             # Workflow thêm người dùng
│   ├── update-user.md          # Workflow cập nhật người dùng
│   └── delete-user.md          # Workflow xóa người dùng
├── skills/                     # Kỹ năng đặc biệt
│   ├── db-analyzer/            # Phân tích database
│   └── api-generator/          # Sinh code API
└── memory/                     # Lưu trữ kiến thức
    ├── bug-fixes.log.md        # Log lỗi đã fix
    └── project-notes.md        # Ghi chú dự án
```

## Các quy tắc chính

- Xem **rules/architecture.md** để hiểu cấu trúc dự án
- Xem **rules/firebase-guidelines.md** cho tương tác Firebase
- Xem **rules/error-handling.md** cho xử lý lỗi

## Các Workflow

- Mỗi workflow nằm trong **workflows/** mô tả chi tiết quy trình cho từng tính năng
- Tuân thủ workflow trước khi implement

## Ghi chú

- Quản lý state bằng Provider hoặc Riverpod
- Sử dụng StreamBuilder cho real-time updates
- Tất cả lỗi phải được log và xử lý
