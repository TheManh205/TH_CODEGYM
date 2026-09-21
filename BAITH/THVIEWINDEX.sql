-- ============================================================================
-- BƯỚC 1 & 2: TẠO CƠ SỞ DỮ LIỆU VÀ BẢNG PRODUCTS VỚI DỮ LIỆU MẪU
-- ============================================================================
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10, 2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(20) DEFAULT 'Available'
);

-- Chèn dữ liệu mẫu
INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) 
VALUES
('P001', 'iPhone 15 Pro', 999.99, 50, 'Apple Flagship Phone', 'Available'),
('P002', 'Samsung Galaxy S24', 899.99, 40, 'Samsung Flagship Phone', 'Available'),
('P003', 'MacBook Pro M3', 1599.99, 20, 'Apple Laptop', 'Available'),
('P004', 'Dell XPS 15', 1299.99, 15, 'Dell Laptop', 'OutOfStock'),
('P005', 'iPad Air 5', 599.99, 30, 'Apple Tablet', 'Available');


-- ============================================================================
-- BƯỚC 3: TẠO INDEX VÀ KIỂM TRA HIỆU NĂNG VỚI EXPLAIN
-- ============================================================================

-- Kiểm tra truy vấn TRƯỚC KHI TẠO INDEX (Sử dụng EXPLAIN để quan sát)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products WHERE productName = 'MacBook Pro M3' AND productPrice = 1599.99;

-- 1. Tạo Unique Index trên cột productCode
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- 2. Tạo Composite Index trên 2 cột productName và productPrice
CREATE INDEX idx_productName_price ON Products(productName, productPrice);

-- Kiểm tra truy vấn SAU KHI TẠO INDEX
EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products WHERE productName = 'MacBook Pro M3' AND productPrice = 1599.99;

/*
  So sánh trước và sau khi tạo Index:
  - Trước khi tạo Index: key = NULL, type = ALL (Full Table Scan), rows quét toàn bộ bảng.
  - Sau khi tạo Index: key = idx_productCode / idx_productName_price, type = const hoặc ref, 
    rows chỉ quét đúng 1 dòng cần tìm -> Tốc độ truy vấn tăng vượt trội.
*/


-- ============================================================================
-- BƯỚC 4: QUẢN LÝ VIEW (TẠO, SỬA, XÓA)
-- ============================================================================

-- 1. Tạo View lấy các thông tin chỉ định
CREATE VIEW w_product_info AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Truy vấn từ View
SELECT * FROM w_product_info;

-- 2. Sửa đổi View (Bổ sung thêm cột productAmount)
CREATE OR REPLACE VIEW w_product_info AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

-- 3. Xóa View
DROP VIEW w_product_info;


-- ============================================================================
-- BƯỚC 5: CÁC STORED PROCEDURE CƠ BẢN (CRUD)
-- ============================================================================

DELIMITER //

-- 1. Stored Procedure: Lấy tất cả sản phẩm
DROP PROCEDURE IF EXISTS sp_getAllProducts //
CREATE PROCEDURE sp_getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

-- 2. Stored Procedure: Thêm mới một sản phẩm
DROP PROCEDURE IF EXISTS sp_addProduct //
CREATE PROCEDURE sp_addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO Products(productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //

-- 3. Stored Procedure: Sửa thông tin sản phẩm theo Id
DROP PROCEDURE IF EXISTS sp_updateProductById //
CREATE PROCEDURE sp_updateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Products 
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //

-- 4. Stored Procedure: Xóa sản phẩm theo Id
DROP PROCEDURE IF EXISTS sp_deleteProductById //
CREATE PROCEDURE sp_deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;

-- ============================================================================
-- DEMO GỌI CÁC STORED PROCEDURE VỪA TẠO
-- ============================================================================

-- Thêm sản phẩm mới
CALL sp_addProduct('P006', 'Sony WH-1000XM5', 399.99, 25, 'Noise Canceling Headphones', 'Available');

-- Xem tất cả
CALL sp_getAllProducts();

-- Cập nhật sản phẩm vừa thêm (Id = 6)
CALL sp_updateProductById(6, 'P006', 'Sony WH-1000XM5', 349.99, 30, 'Discounted Headphones', 'Available');

-- Xóa sản phẩm vừa thêm (Id = 6)
CALL sp_deleteProductById(6);

-- Kiểm tra lại danh sách
CALL sp_getAllProducts();