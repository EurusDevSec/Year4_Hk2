# THỰC HÀNH ÔN TẬP LÝ THUYẾT

Xác định các yếu tố cơ bản của Machine Learning như tác vụ (task) T, hiệu năng (performance) P, và kinh nghiệm (experience) E và cho biết loại thuật toán được sử dụng (có giám sát hoặc không giám sát) trong các tình huống sau:

1. Xây dựng một hệ thống Machine Learning để lọc các thư rác (spam email).

- T: Dự đoán (để lọc) những thư điện tử nào là thư rác (spam email).
- P: Tỉ lệ (%) số lượng các thư điện tử gửi đến được phân loại chính xác.
- E: Một tập các thư điện tử (mẫu), mỗi mẫu gồm nội dung và được gắn với nhãn tương ứng (thư thường / thư rác).
- **Đáp án - Loại học: Có giám sát (Phân loại).**

2. Xây dựng một hệ thống Machine Learning để phát hiện các giao dịch tài chính gian lận.

- T: Dự đoán những giao dịch nào là giao dịch gian lận.
- P: Tỉ lệ (%) số lượng các giao dịch tài chính được phân loại chính xác.
- E: Một tập giao dịch tài chính (mẫu), mỗi mẫu gồm nội dung và được gắn với nhãn (gian lận / không gian lận).
- **Đáp án - Loại học: Có giám sát (Phân loại).**

3. Xây dựng hệ thống gom nhóm văn bản dựa trên nội dung.

- T: Gom nhóm văn bản theo nội dung chung.
- P: Tỉ lệ (%) văn bản được gom nhóm chính xác.
- E: Tập văn bản với đặc trưng nội dung (không có nhãn).
- **Đáp án - Loại học: Không giám sát (Phân cụm).**

4. Dự đoán giới tính dựa trên tên.

- T: Dự đoán giới tính dựa trên tên.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu tên và nhãn (Nam/Nữ).
- **Đáp án - Loại học: Có giám sát (Phân loại).**

5. Dự đoán số lượt xem video.

- T: Dự đoán lượt xem dựa trên đặc trưng video.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu video và số lượt xem (giá trị số thực).
- **Đáp án - Loại học: Có giám sát (Hồi quy).**

6. Dự đoán thời tiết.

- T: Dự đoán thời tiết dựa trên dữ liệu lịch sử.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu thời tiết và nhãn (mưa/nắng/nhiệt độ).
- **Đáp án - Loại học: Có giám sát (Phân loại hoặc Hồi quy, tùy vào việc dự báo trạng thái hay dự báo nhiệt độ).**

7. Dự đoán dự án thành công.

- T: Dự đoán thành công/không thành công.
- P: Tỉ lệ (%) phân loại chính xác.
- E: Tập dữ liệu dự án và nhãn.
- **Đáp án - Loại học: Có giám sát (Phân loại).**

8. Dự đoán sự cố hệ thống.

- T: Dự đoán sự cố dựa trên thông số tài nguyên.
- P: Tỉ lệ (%) phân loại chính xác.
- E: Tập dữ liệu sự cố và nhãn.
- **Đáp án - Loại học: Có giám sát (Phân loại).**

9. Dự đoán lưu lượng giao thông.

- T: Dự đoán lưu lượng giao thông.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu giao thông (giá trị số liên tục).
- **Đáp án - Loại học: Có giám sát (Hồi quy).**

10. Dự đoán điểm tổng kết học sinh.

- T: Dự đoán điểm tổng kết.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu điểm và đặc trưng học sinh (giá trị số).
- **Đáp án - Loại học: Có giám sát (Hồi quy).**

11. Dự đoán độ tuổi từ khuôn mặt.

- T: Dự đoán độ tuổi.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu hình ảnh và độ tuổi (giá trị số).
- **Đáp án - Loại học: Có giám sát (Hồi quy).**

12. Dự đoán giá cổ phiếu.

- T: Dự đoán giá cổ phiếu.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu giá cổ phiếu (giá trị số).
- **Đáp án - Loại học: Có giám sát (Hồi quy).**

13. Phân loại hình ảnh y học.

- T: Phân loại hình ảnh bệnh/không bệnh.
- P: Tỉ lệ (%) phân loại chính xác.
- E: Tập dữ liệu hình ảnh và nhãn.
- **Đáp án - Loại học: Có giám sát (Phân loại).**

14. Dự đoán khả năng trả nợ.

- T: Dự đoán khả năng trả nợ.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu người vay và nhãn (có trả được hay không).
- **Đáp án - Loại học: Có giám sát (Phân loại).**

15. Dự đoán điểm cuối kỳ sinh viên.

- T: Dự đoán điểm cuối kỳ.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu điểm và thời gian học.
- **Đáp án - Loại học: Có giám sát (Hồi quy).**

16. Phân loại bài viết diễn đàn.

- T: Phân loại bài viết vào diễn đàn phù hợp.
- P: Tỉ lệ (%) phân loại chính xác.
- E: Tập dữ liệu bài viết (có gán nhãn chủ đề).
- **Đáp án - Loại học: Có giám sát (Phân loại).**

17. Dự đoán việc làm trái ngành.

- T: Dự đoán trái ngành/không trái ngành.
- P: Tỉ lệ (%) phân loại chính xác.
- E: Tập dữ liệu sinh viên và nhãn.
- **Đáp án - Loại học: Có giám sát (Phân loại).**

18. Dự đoán giá nhà.

- T: Dự đoán giá nhà.
- P: Tỉ lệ (%) dự đoán chính xác.
- E: Tập dữ liệu nhà ở (có giá trị cụ thể).
- **Đáp án - Loại học: Có giám sát (Hồi quy).**

19. Phân cụm khách hàng.

- T: Phân nhóm khách hàng.
- P: Tỉ lệ (%) phân nhóm chính xác.
- E: Tập dữ liệu hành vi mua sắm (không có nhãn phân nhóm sẵn).
- **Đáp án - Loại học: Không giám sát (Phân cụm).**

20. Phân loại tài liệu thư viện.

- T: Phân loại tài liệu mới.
- P: Tỉ lệ (%) phân loại chính xác.
- E: Tập dữ liệu tài liệu và nhãn (thể loại).
- **Đáp án - Loại học: Có giám sát (Phân loại).**
