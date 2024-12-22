use testing_system_db ;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale 
WITH CTE_nhanvien_sale AS (
    SELECT FULLNAME
    FROM `account` A
    JOIN department D ON A.`DepartmentID` = D.`DepartmentID`
    WHERE D.`DepartmentName` = 'Sale'
)
SELECT *
FROM CTE_nhanvien_sale;

--Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
WITH TOP1ACC AS   (
    SELECT `AccountID`, COUNT(`GroupID`) AS SoGroupThamGia   
    FROM groupaccount
    GROUP BY `AccountID`
    ORDER BY COUNT(`GroupID`) DESC
    LIMIT 1)
SELECT A.`AccountID`,A.`Email`,A.`FullName` FROM
`account` A JOIN groupaccount G ON A.`AccountID`=G.`AccountID`
GROUP BY A.`AccountID`,A.`Email`,A.`FullName`
HAVING COUNT(`GroupID`) IN (SELECT SoGroupThamGia FROM TOP1ACC)



--Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi làquá dài) và xóa nó đi
CREATE OR REPLACE VIEW CAUHOI_QUA_DAI AS
SELECT * FROM question
WHERE LENGTH(CONTENT) > 300;
DELETE FROM CAUHOI_QUA_DAI

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
WITH TOP1DEPARTMENT AS   (
    SELECT `DepartmentID`, COUNT(`AccountID`) AS SoNhanVien
    FROM `account` A
    GROUP BY `DepartmentID`
    ORDER BY COUNT(`AccountID`) DESC
    LIMIT 1)
SELECT D.`DepartmentID`, DEPARTMENTNAME
FROM department D JOIN `account` A ON D.`DepartmentID` = A.`DepartmentID`
GROUP BY D.`DepartmentID`
HAVING COUNT(`AccountID`) IN (SELECT SoNhanVien FROM TOP1DEPARTMENT)

--Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
WITH CAUHOI AS (
    SELECT questionID, CONTENT
    FROM question Q JOIN `account` A ON Q.`CreatorID` = A.`AccountID`
    WHERE `FullName` LIKE "Nguyễn%")
SELECT * FROM CAUHOI
