-- Active: 1733060084696@@127.0.0.1@3306@testing_system_db
USE Testing_System_Db;

--Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
DELIMITER $$
CREATE PROCEDURE Q1 (IN department_name NVARCHAR(30))
BEGIN
    SELECT UserName, FullName
    FROM department D JOIN `account` A ON D.`DepartmentID`= A.`DepartmentID`
    WHERE DepartmentName = department_name;
END$$
DELIMITER ;
CALL Q1('Sale')

--Question 2: Tạo store để in ra số lượng account trong mỗi group
DELIMITER $$
CREATE PROCEDURE Q2()
BEGIN
    SELECT GroupName, COUNT(AccountID) AS SoLuongAcc
    FROM `group` G JOIN groupaccount GA ON G.`GroupID` = GA.`GroupID`
    GROUP BY GroupName;
END$$
DELIMITER;
CALL `Q2`

--Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DELIMITER $$
CREATE PROCEDURE Q3()
BEGIN
    SELECT TypeName, COUNT(QuestionID) AS SoLuongCauHoi
    FROM typequestion T JOIN question Q ON T.`TypeID` = Q.`TypeID`
    GROUP BY TypeName;
END$$
DELIMITER;
CALL `Q3`

--Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DELIMITER $$
CREATE PROCEDURE Q4()
BEGIN
    SELECT TypeID
    FROM question Q
    GROUP BY `TypeID`
    ORDER BY COUNT(QuestionID) DESC
    LIMIT 1;
END$$
DELIMITER;
CALL `Q4`

--Question 5: Sử dụng store ở question 4 để tìm ra tên của type question 
DELIMITER $$
CREATE PROCEDURE Q5()
BEGIN
    WITH CTE AS(
        SELECT TypeID
        FROM question Q
        GROUP BY `TypeID`
        ORDER BY COUNT(QuestionID) DESC
        LIMIT 1
    )
    SELECT TypeName
    FROM typequestion T JOIN CTE C ON T.`TypeID` = C.`TypeID`;
END$$
DELIMITER;
CALL `Q5`

/* Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của
người dùng nhập vào */
DELIMITER $$
CREATE PROCEDURE Q6 (IN search_string NVARCHAR(30))
BEGIN
    SELECT * FROM `group` WHERE `GroupName` LIKE CONCAT('%', search_string, '%');
    SELECT * FROM `account` WHERE `FullName` LIKE CONCAT('%', search_string, '%');
END$$
DELIMITER ;
CALL Q6('FI')

/* Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
trong store sẽ tự động gán:
    username sẽ giống email nhưng bỏ phần @..mail đi
    positionID: sẽ có default là developer
    departmentID: sẽ được cho vào 1 phòng chờ */
DELIMITER $$
CREATE PROCEDURE Q7 (IN fullName_new NVARCHAR(30), IN Email_new NVARCHAR(30))
BEGIN
    DECLARE UserName_new NVARCHAR(30) ;
    DECLARE PositionID_new TINYINT;
    DECLARE DepartmentID_new TINYINT;
    DECLARE CreateDate_new DATE;

    SET UserName_new = SUBSTRING_INDEX(Email_new, '@', 1);
    SET PositionID_new = 1; 
    SET DepartmentID_new = 1; 
    SET CreateDate_new = NOW();     

    INSERT INTO `account`(`Email`, `Username`, `FullName`, `DepartmentID`, `PositionID`, `CreateDate`) 
    VALUES( 
        Email_new, UserName_new, fullName_new, DepartmentID_new, PositionID_new, CreateDate_new
    );
END$$
DELIMITER ;
CALL Q7('NguyeVanX', 'X1234@gmail.com')

/* Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để
thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất*/
DELIMITER $$
CREATE PROCEDURE Q8 (IN search_Q8 NVARCHAR(30))
BEGIN
    SELECT QuestionID, Content, t.TypeName
    FROM question Q JOIN typequestion T ON Q.`TypeID` = T.`TypeID`
    WHERE `TypeName` = search_Q8
    ORDER BY LENGTH(`Content`) DESC
    LIMIT 1;
END$$
DELIMITER ;
CALL Q8('Essay')

--Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DELIMITER $$
CREATE PROCEDURE Q9 (IN EXAMID_DROP TINYINT )
BEGIN
    DELETE FROM ExamQuestion WHERE `ExamID` = EXAMID_DROP;
    DELETE FROM Exam WHERE `ExamID` = EXAMID_DROP;
END$$
DELIMITER ;
CALL Q9('2')

/*Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng
store ở câu 9 để xóa)
Sau đó in số lượng record đã remove từ các table liên quan trong khi removing*/



