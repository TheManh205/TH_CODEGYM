-- 1. THAM SỐ IN (Tham số đầu vào)
-- Dùng để truyền dữ liệu từ bên ngoài vào bên trong Procedure
DELIMITER //
CREATE PROCEDURE getCusById(IN cusNum INT)
BEGIN
    SELECT * FROM customers WHERE customerNumber = cusNum;
END //
DELIMITER ;

-- Gọi Procedure với tham số IN = 175
CALL getCusById(175);


-- 2. THAM SỐ OUT (Tham số đầu ra)
-- Dùng để hứng giá trị tính toán từ bên trong Procedure gán ra biến bên ngoài
DELIMITER //
CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //
DELIMITER ;

-- Gọi Procedure và dùng biến session @total để nhận kết quả
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total;


-- 3. THAM SỐ INOUT (Vừa là đầu vào, vừa là đầu ra)
-- Nhận giá trị ban đầu truyền vào, biến đổi nó và trả về giá trị mới
DELIMITER //
CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //
DELIMITER ;

-- Khởi tạo biến @counter = 1 và gọi Procedure nhiều lần
SET @counter = 1;
CALL SetCounter(@counter, 1); -- @counter thành 2
CALL SetCounter(@counter, 1); -- @counter thành 3
CALL SetCounter(@counter, 5); -- @counter thành 8

SELECT @counter; -- Kết quả: 8