# So Sánh Kế Hoạch Thực Thi (Execution Plan)

### Trước khi tối ưu (Legacy Query)
- **`type`**: `ALL` (Phải quét toàn bộ bảng 5,000,000 dòng).
- **`key`**: `NULL` (Không thể dùng Index do hàm `YEAR()` và `MONTH()`).
- **`Extra`**: `Using where` (CPU bị quá tải do phải tính toán hàm trên từng dòng).

### Sau khi tối ưu (Optimized Query)
- **`type`**: `range` / `ref` (Chỉ truy xuất trên nhánh B-Tree thỏa mãn khoảng thời gian).
- **`key`**: `idx_type_date` (Khai thác thành công Composite Index).
- **`rows`**: Giảm từ 5.000.000 dòng xuống chỉ còn số dòng thực tế của tháng 6/2026.
- **`Extra`**: `Using index condition` (Tối ưu hóa thời gian I/O và giải phóng CPU).