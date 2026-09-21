USE smartfactory_db;

-- ---------------------------------------------------------------------
-- BƯỚC 1: Truy vấn kiểm tra dung lượng Data & Index (MB) TRƯỚC khi tối ưu
-- ---------------------------------------------------------------------
SELECT 
    table_name AS 'Table',
    ROUND(((data_length) / 1024 / 1024), 2) AS 'Data Size (MB)',
    ROUND(((index_length) / 1024 / 1024), 2) AS 'Index Size (MB)',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- ---------------------------------------------------------------------
-- BƯỚC 2: Loại bỏ "Fat Index" và thay thế bằng "Lean Index"
-- ---------------------------------------------------------------------
-- 1. Xóa Covering Index cồng kềnh cũ
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 2. Tạo Index tinh gọn phục vụ đúng điều kiện WHERE / ORDER BY
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

-- ---------------------------------------------------------------------
-- BƯỚC 3: Truy vấn kiểm tra lại dung lượng SAU KHI TỐI ƯU
-- ---------------------------------------------------------------------
SELECT 
    table_name AS 'Table',
    ROUND(((data_length) / 1024 / 1024), 2) AS 'Data Size (MB)',
    ROUND(((index_length) / 1024 / 1024), 2) AS 'Index Size (MB)',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- ---------------------------------------------------------------------
-- BƯỚC 4: Kiểm tra execution plan bằng lệnh EXPLAIN
-- ---------------------------------------------------------------------
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';