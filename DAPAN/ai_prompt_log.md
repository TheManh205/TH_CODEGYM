# Nhật Ký Tương Tác AI (Prompt Log)

### Prompt 1: Giải thích cơ chế Non-SARGable và Index
- **User:** Trong MySQL, nếu tôi tạo Index cho một cột ngày tháng, nhưng trong mệnh đề WHERE tôi lại viết WHERE YEAR(col) = 2026, tại sao MySQL lại từ chối sử dụng Index và phải quét toàn bộ bảng (Full Table Scan)?
- **AI Response:** Khi bạn bọc một hàm lên cột ngày tháng, giá trị trong cây Index (vốn lưu giá trị gốc) bị biến đổi. B-Tree Index không thể dự đoán được giá trị sau hàm nếu không chạy qua toàn bộ dữ liệu. Do đó, Optimizer buộc phải chuyển sang Full Table Scan để tính toán hàm trên từng dòng.

### Prompt 2: Thiết kế Thứ tự Cột trong Composite Index
- **User:** Khi thiết kế một Composite Index trong MySQL cho cột (transaction_type, created_at), thứ tự các cột trong Index có quan trọng không? Tôi nên đặt cột nào đứng trước để có hiệu suất lọc dữ liệu (Selectivity) tốt nhất?
- **AI Response:** Thứ tự cột rất quan trọng dựa trên quy tắc Leftmost Prefix. Bạn nên đặt cột lọc bằng toán tử `=` (ở đây là `transaction_type`) lên trước, sau đó mới đến cột lọc dạng khoảng Range (`created_at`). Điều này giúp B-Tree thu hẹp phạm vi chính xác trước khi duyệt khoảng.

### Prompt 3: Xem chi tiết thời gian thực thi bằng Profiling
- **User:** Làm thế nào để tôi có thể xem được chi tiết thời gian thực thi (Execution Time) của một câu lệnh SQL thay vì chỉ xem Execution Plan trong MySQL?
- **AI Response:** Bạn có thể bật tính năng Profiling bằng câu lệnh `SET profiling = 1;`, sau đó chạy truy vấn SQL và kiểm tra kết quả chi tiết bằng lệnh `SHOW PROFILES;` hoặc `SHOW PROFILE FOR QUERY 1;`.