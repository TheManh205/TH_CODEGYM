-- ========================================================
-- HỆ THỐNG PAYFLOW - TRUY VẤN ĐÃ TỐI ƯU HÓA HIỆU NĂNG
-- ========================================================

CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. Tạo Composite Index cho cột tìm kiếm
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- 2. Câu lệnh TRUY VẤN CŨ (Non-SARGable - Đã kiểm tra qua EXPLAIN)
-- EXPLAIN 
-- SELECT SUM(amount) AS total_deposit
-- FROM Transactions
-- WHERE transaction_type = 'DEPOSIT' 
--   AND YEAR(created_at) = 2026 
--   AND MONTH(created_at) = 6;
-- -> Kết quả EXPLAIN cũ: type = ALL, key = NULL, rows = 5,000,000

-- ========================================================
-- 3. CÂU LỆNH TRUY VẤN MỚI (Tối ưu SARGable + B-Tree Index)
-- ========================================================
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';
-- -> Kết quả EXPLAIN mới: type = range (hoặc ref), key = idx_type_date, rows = vài ngàn dòng.