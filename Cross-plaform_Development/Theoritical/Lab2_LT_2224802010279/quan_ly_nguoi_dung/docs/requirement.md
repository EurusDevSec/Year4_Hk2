Bài tập tổng hợp: Xây dựng ứng dụng Quản lý Người dùng với Flutter
Mô tả:
Xây dựng một ứng dụng quản lý người dùng đơn giản, trong đó người dùng có thể thực hiện các thao tác như:

Thêm người dùng mới
Hiển thị danh sách người dùng
Cập nhật thông tin người dùng
Xóa người dùng
Quản lý trạng thái tải dữ liệu (loading) và xử lý lỗi
Yêu cầu chi tiết:
Thiết lập Backend:

Sử dụng Firebase và Cloud Firestore để thiết lập backend. Tạo collection với cấu trúc bảng lưu thông tin users gồm các trường: id, name, email, age. Kết nối Firebase với ứng dụng Flutter bằng các package: firebase_core, cloud_firestore.
Thêm người dùng:

Tạo form nhập thông tin người dùng bao gồm name, email, và age.
Khi nhấn nút Thêm. Gửi dữ liệu lên Firestore bằng phương thức add()
Sau khi người dùng mới được thêm thành công, hiển thị thông báo (SnackBar) cho người dùng và cập nhật danh sách người dùng trên màn hình.
Hiển thị danh sách người dùng:

Sử dụng StreamBuilder (real-time) hoặc FutureBuilder để lấy dữ liệu từ Firestore
Hiển thị danh sách bằng danh sách Listview. Mỗi item hiển thị (name, email, age)
Cập nhật thông tin người dùng:

Điều hướng đến màn hình chỉnh sửa khi nhấn vào một user. Cho phép sửa (name, email, age)
Sau khi cập nhật thành công, quay về màn hình danh sách và dữ liệu tự động được cập nhật trên màn hình.
Xóa người dùng:

Thêm nút xóa trên mỗi item user. Khi người dùng nhấn vào nút "Xóa", hiển thị hộp thoại xác nhận (AlertDialog) nếu đồng ý thực hiện việc xóa.
Sau khi xóa thành công, hiển thị danh sách người dùng được cập nhật.
Quản lý trạng thái tải:

Sử dụng widget CircularProgressIndicator và áp dụng cho việc load danh sách, thêm/sửa/xóa.
Xử lý lỗi (Error Handling):

Dùng try-catch để bắt lỗi.
Các lỗi cần xử lý: Lỗi kết nối mạng, lỗi Firebase
Hiển thị lỗi bằng SnackBar hoặc Dialog. Ghi log lỗi ra console.
Gợi ý:
Sinh viên có thể sử dụng StatefulWidget hoặc Provider / Riverpod để quản lý state.
Firebase Firestore SDK và Axios sẽ giúp đơn giản hóa việc tương tác với cơ sở dữ liệu.
Các chức năng như thêm, cập nhật và xóa người dùng cần được triển khai với đầy đủ kiểm tra dữ liệu đầu vào để tránh lỗi dữ liệu.
Sau khi thực hiện bài tập xong tiến hành:

1/ Quay lại màn hình điện thoại lab đã hoàn thành có gắn tên + mssv upload lên youtube.
2/ Link youtube đặt trong file .txt, gửi lên elearning.
