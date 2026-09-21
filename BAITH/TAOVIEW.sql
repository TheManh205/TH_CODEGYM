-- 1. TẠO VIEW
-- Tạo bảng ảo customer_views chứa 3 cột cơ bản từ bảng customers
CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Truy vấn dữ liệu trực tiếp từ View vừa tạo
SELECT * FROM customer_views;


-- 2. CẬP NHẬT VIEW (Sửa đổi cấu trúc / câu lệnh SELECT của View)
-- Sử dụng CREATE OR REPLACE VIEW để ghi đè định nghĩa View
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Kiểm tra lại View sau khi đã cập nhật điều kiện và cột
SELECT * FROM customer_views;


-- 3. XÓA VIEW
-- Xóa bảng ảo khỏi cơ sở dữ liệu khi không còn sử dụng
DROP VIEW customer_views;