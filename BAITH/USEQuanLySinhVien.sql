USE QuanLySinhVien;

SELECT *
FROM Subject
WHERE Credit = (SELECT MAX(Credit) FROM Subject);


SELECT S.SubId, S.SubName, S.Credit, S.Status, M.Mark
FROM Subject S
JOIN Mark M ON S.SubId = M.SubId
WHERE M.Mark = (SELECT MAX(Mark) FROM Mark);

SELECT 
    S.StudentId, 
    S.StudentName, 
    S.Address, 
    S.Phone, 
    S.Status, 
    S.ClassId,
    IFNULL(AVG(M.Mark), 0) AS DiemTrungBinh
FROM Student S
LEFT JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName, S.Address, S.Phone, S.Status, S.ClassId
ORDER BY DiemTrungBinh DESC;