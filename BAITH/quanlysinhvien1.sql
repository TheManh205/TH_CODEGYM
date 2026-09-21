-- Create Database
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- 1. DDL: Create Tables
CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    cName VARCHAR(25),
    cAge TINYINT
);

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- 2. DML: Insert Data
INSERT INTO Customer VALUES 
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES 
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Product VALUES 
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO OrderDetail VALUES 
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(2, 3, 8),
(2, 5, 4),
(2, 3, 3); -- Luu y: Neu bi trung primary key (2, 3), bo qua dong nay hoac cap nhat them so luong.

-- 3. Queries

-- Yeu cau 1: Hien thi cac thong tin oID, oDate, oTotalPrice cua tat ca hoa don trong bang Order
SELECT oID, oDate, oTotalPrice 
FROM `Order`;

-- Yeu cau 2: Hien thi danh sach cac khach hang da mua hang, va danh sach san pham duoc mua boi cac khach
SELECT 
    C.cName AS CustomerName, 
    P.pName AS ProductName
FROM Customer C
JOIN `Order` O ON C.cID = O.cID
JOIN OrderDetail OD ON O.oID = OD.oID
JOIN Product P ON OD.pID = P.pID;

-- Yeu cau 3: Hien thi ten nhung khach hang khong mua bat ky mot san pham nao (Anti-Join)
SELECT C.cName 
FROM Customer C
LEFT JOIN `Order` O ON C.cID = O.cID
WHERE O.oID IS NULL;

-- Yeu cau 4: Hien thi ma hoa don, ngay ban va gia tien cua tung hoa don (odQTY * pPrice)
SELECT 
    O.oID, 
    O.oDate, 
    SUM(OD.odQTY * P.pPrice) AS TotalPrice
FROM `Order` O
JOIN OrderDetail OD ON O.oID = OD.oID
JOIN Product P ON OD.pID = P.pID
GROUP BY O.oID, O.oDate;