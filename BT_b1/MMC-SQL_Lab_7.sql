-- Active: 1733060084696@@127.0.0.1@3306@testing_system_db
USE TESTING_SYSTEM_DB;

--Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
CREATE TRIGGER Q1
BEFORE INSERT ON `GROUP`
FOR EACH ROW 
BEGIN 
    DECLARE CREATE_DATE DATE;
    SET CREATE_DATE = DATE_SUB(NOW(), INTERVAL 1 YEAR);
    IF NEW.CreateDate < CREATE_DATE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the them vao Group tao truoc 1 nam';
    END IF;
END;

/*Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
department "Sale" nữa, khi thêm thì hiện ra thông báo "Department "Sale" cannot add
more user"*/
CREATE TRIGGER Q2
BEFORE INSERT ON ACCOUNT
FOR EACH ROW
BEGIN
    IF NEW.DepartmentID = (SELECT DEPARTMENTID FROM department WHERE `DepartmentName` = 'SALE') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
    END IF;
END;

--Question 3: Cấu hình 1 group có nhiều nhất là 5 user
CREATE TRIGGER Q3
BEFORE INSERT ON GROUPACCOUNT
FOR EACH ROW
BEGIN
    DECLARE COUNT_ACC TINYINT;
    SELECT groupaccount.`GroupID`, COUNT(ACCOUNTID) INTO COUNT_ACC
    FROM groupaccount 
    GROUP BY groupaccount.`GroupID`
    HAVING groupaccount.`GroupID` = NEW.`GroupID`;
    IF (COUNT_ACC > 5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Group da co toi da 5 user';
    END IF;    
END;

--Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
CREATE TRIGGER Q4
BEFORE INSERT ON EXAMQUESTION
FOR EACH ROW
BEGIN
    DECLARE COUNT_Q TINYINT;
    SELECT EXAMQUESTION.`EXAMID`, COUNT(QUESTIONID) INTO COUNT_Q
    FROM EXAMQUESTION 
    GROUP BY EXAMQUESTION.`EXAMID`
    HAVING EXAMQUESTION.`EXAMID` = NEW.`EXAMID`;
    IF (COUNT_Q > 10) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bai thi da co toi da 10 Question';
    END IF;    
END;

/*Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), còn lại các tài
khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó.*/
CREATE TRIGGER Q5
BEFORE DELETE ON ACCOUNT
FOR EACH ROW
BEGIN
    IF (OLD.EMAIL= 'admin@gmail.com') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the xoa email admin';
    END IF;    
END;

/*Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account,
hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì
sẽ được phân vào phòng ban "waiting Department".*/
INSERT INTO department (`DepartmentName`) VALUES ('waiting Department');
CREATE TRIGGER Q6
BEFORE INSERT ON ACCOUNT
FOR EACH ROW
BEGIN
    IF (NEW.departmentID IS NULL) THEN
        SET NEW.departmentID = (SELECT departmentID FROM department WHERE `DepartmentName`='waiting Department');
    END IF;
END;

INSERT INTO `account` (`Email`, `Username`, `FullName`, `PositionID`,
`CreateDate`)
VALUES ('1', '1','1','1',NOW());

/*Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question,
trong đó có tối đa 2 đáp án đúng.*/
CREATE TRIGGER Q7
BEFORE INSERT ON ANSWER
FOR EACH ROW
BEGIN
    DECLARE COUNT_ANSWERS TINYINT;
    DECLARE COUNT_ANSWERS_TRUE TINYINT;

    SELECT A.QUESTIONID, COUNT(A.ANSWERID) INTO COUNT_ANSWERS
    FROM ANSWER A
    WHERE A.`QuestionID` = NEW.`QuestionID`
    GROUP BY QUESTIONID;

    SELECT QUESTIONID, COUNT(ANSWERID) INTO COUNT_ANSWERS_TRUE
    FROM ANSWER
    WHERE A.`QuestionID` = NEW.`QuestionID`
    GROUP BY QUESTIONID
    HAVING `isCorrect` = 'TRUE';

    IF (COUNT_ANSWERS > 4 OR COUNT_ANSWERS_TRUE > 2) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the them answer';
    END IF;
END;

/*Question 8: Viết trigger sửa lại dữ liệu cho đúng:
● Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
● Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database*/
ALTER TABLE account
ADD COLUMN gender ENUM('M', 'F', 'U') NOT NULL DEFAULT 'U';
CREATE TRIGGER Q7
BEFORE INSERT ON ACCOUNT
FOR EACH ROW
BEGIN
    IF (NEW.GENDER = 'NAM') THEN
        SET NEW.GENDER = 'M';
    ELSEIF (NEW.GENDER = 'Nu') THEN
        SET NEW.GENDER = 'F';
    ELSEIF (NEW.GENDER = 'Chua Xac Dinh') THEN
        SET NEW.GENDER = 'U';
    END IF;
END;

--Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
CREATE TRIGGER Q9
BEFORE DELETE ON ACCOUNT
FOR EACH ROW
BEGIN
    IF (OLD.CreateDate = DATE_SUB(NOW(), INTERVAL 1 DAY)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the xoa bai thi nay';
    END IF;    
END;

--Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các question khi question đó chưa nằm trong exam nào
CREATE TRIGGER Q10A
BEFORE UPDATE ON question
FOR EACH ROW
BEGIN
    IF (NEW.QUESTIONID IN (SELECT QUESTIONID FROM examquestion)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the thay doi cau hoi nay';
    END IF;
END;

CREATE TRIGGER Q10B
BEFORE DELETE ON question
FOR EACH ROW
BEGIN
    IF (OLD.QUESTIONID IN (SELECT QUESTIONID FROM examquestion)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the xoa cau hoi nay';
    END IF;
END;

/*Question 12: Lấy ra thông tin exam trong đó:
● Duration <= 30 thì sẽ đổi thành giá trị "Short time"
● 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
● Duration > 60 thì sẽ đổi thành giá trị "Long time"*/

SELECT * FROM EXAM;
SELECT EXAMID,CODE, TITLE, CASE
    WHEN Duration <='00:30:00' THEN 'Short time'
    WHEN '00:30:00' < Duration AND Duration <= '01:00:00' THEN 'Medium time'
    WHEN '01:00:00' < Duration THEN 'Long time'
    END AS Duration, CREATORID, CREATEDATE
FROM EXAM 
    
/*Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên là
the_number_user_amount và mang giá trị được quy định như sau:
● Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
● Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
● Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher*/
SELECT G.GROUPID, GROUPNAME, CASE
    WHEN COUNT(ACCOUNTID) <= 5 THEN 'few'
    WHEN COUNT(ACCOUNTID) <= 20 THEN 'normal'
    WHEN COUNT(ACCOUNTID) >  20 THEN 'higher'
    END AS the_number_user_amount
FROM `group` G JOIN groupaccount GA ON G.`GroupID` = GA.`GroupID`
GROUP BY G.GROUPID, GROUPNAME

--Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
SELECT DEPARTMENTNAME, CASE 
    WHEN COUNT(ACCOUNTID) = 0 THEN 'Không có User'  
    ELSE COUNT(ACCOUNTID) END AS SoLuongUser
FROM department D JOIN `account` A ON D.`DepartmentID` = A.`DepartmentID`
GROUP BY DEPARTMENTNAME