-- Bước 1: Đổi DELIMITER thành // và tạo Stored Procedure đầu tiên
DELIMITER //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;

-- Bước 2: Gọi Stored Procedure vừa tạo để thực thi
CALL findAllCustomers();

-- Bước 3: Sửa Stored Procedure (bằng cách Xóa cũ - Tạo lại mới)
DELIMITER //

DROP PROCEDURE IF EXISTS `findAllCustomers`//

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //

DELIMITER ;

-- Bước 4: Gọi lại Stored Procedure sau khi đã cập nhật
CALL findAllCustomers();