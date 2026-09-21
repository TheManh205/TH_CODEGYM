USE quickfeed_db;

-- ---------------------------------------------------------------------
-- BƯỚC A: Truy vấn kiểm tra dung lượng Data & Index (MB) TRƯỚC khi tối ưu
-- ---------------------------------------------------------------------
SELECT 
    table_name AS 'Table',
    ROUND(((data_length) / 1024 / 1024), 2) AS 'Data Size (MB)',
    ROUND(((index_length) / 1024 / 1024), 2) AS 'Index Size (MB)',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- ---------------------------------------------------------------------
-- BƯỚC B: Tiến hành "Phẫu thuật" - DROP các Index vô hại / tốn tài nguyên
-- ---------------------------------------------------------------------
ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- ---------------------------------------------------------------------
-- BƯỚC C: Truy vấn kiểm tra lại dung lượng SAU khi đã giải phóng đĩa
-- ---------------------------------------------------------------------
SELECT 
    table_name AS 'Table',
    ROUND(((data_length) / 1024 / 1024), 2) AS 'Data Size (MB)',
    ROUND(((index_length) / 1024 / 1024), 2) AS 'Index Size (MB)',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';