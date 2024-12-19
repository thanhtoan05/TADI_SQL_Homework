USE Testing_System_Db;

SELECT * FROM Department;

SELECT DepartmentID FROM  Department
WHERE DepartmentName = 'Sale';

SELECT * FROM ACCOUNT
ORDER BY LENGTH(FullName) DESC
LIMIT 1;

SELECT * FROM ACCOUNT
WHERE ACCOUNTID = 3
ORDER BY LENGTH(FullName) DESC
LIMIT 1; 

SELECT GroupName 
FROM `Group`
WHERE CreateDate < '2019-12-20';

SELECT q.QuestionID 
FROM Question q JOIN Answer a on q.`QuestionID` = a.`QuestionID`
GROUP BY q.`QuestionID` 
HAVING COUNT(`AnswerID`) >=4;

SELECT ExamID 
FROM exam 
WHERE `Duration` >= '1:00:00'
AND `CreateDate` < '2019-12-20';

SELECT * FROM `group`
ORDER BY `CreateDate` DESC
LIMIT 5;

SELECT COUNT(*)
FROM `account` 
WHERE `DepartmentID` = 2;

SELECT FullName
FROM `account`
WHERE `FullName` LIKE 'D%' AND `FullName` LIKE '%O';

DELETE FROM exam
WHERE `CreateDate` < '2019-12-20';

DELETE FROM question
WHERE `Content` LIKE 'Câu hỏi%';

UPDATE `account`
SET `FullName` = 'Lô Văn Đề', `Email` = 'lo.vande@mmc.edu.vn'
WHERE  `AccountID` = 5;

UPDATE `groupaccount`
SET `GroupID` = 4
WHERE  `AccountID` = 5;

