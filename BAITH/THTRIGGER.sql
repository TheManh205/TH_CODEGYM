-- Bước 1: Tạo Database và Bảng dữ liệu
CREATE DATABASE IF NOT EXISTS company;
USE company;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- Bước 2: Tạo Trigger kiểm tra trước khi INSERT
DELIMITER //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- Bước 3: Thêm dữ liệu để kiểm thử Trigger
INSERT INTO employees (name, department, salary)
VALUES 
    ('John Doe', 'A', 3500),       -- Sẽ tự đổi sang 'Sales'
    ('Jane Smith', 'A', 2000),     -- Sẽ tự đổi sang 'Support'
    ('David Johnson', 'A', 6000);  -- Sẽ tự đổi sang 'Management'

-- Bước 4: Kiểm tra kết quả
SELECT * FROM employees;