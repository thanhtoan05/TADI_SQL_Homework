USE Testing_System_Db;

INSERT INTO Department (DepartmentName) VALUES
('Sale'), 
('Marketing'), 
('HR'), 
('Finance'), 
('IT');

select * from department

INSERT INTO `Position` (PositionName) VALUES
('Developer'), 
('Tester'), 
('Scrum Master'), 
('Project Manager'), 
('Business Analyst');

select * from `Position`


INSERT INTO Account (Email, Username, FullName, DepartmentID, PositionID, CreateDate) VALUES
('john.doe@example.com', 'johndoe', 'John Doe', 1, 1, '2024-01-01'),
('jane.smith@example.com', 'janesmith', 'Jane Smith', 2, 2, '2024-02-01'),
('bob.jones@example.com', 'bobjones', 'Bob Jones', 3, 3, '2024-03-01'),
('alice.white@example.com', 'alicewhite', 'Alice White', 4, 4, '2024-04-01'),
('charlie.brown@example.com', 'charliebrown', 'Charlie Brown', 5, 5, '2024-05-01');

INSERT INTO `Group` (GroupName, CreatorID, CreateDate) VALUES
('Dev Team', 1, '2024-01-01'),
('Marketing Team', 2, '2024-02-01'),
('HR Team', 3, '2024-03-01'),
('Finance Team', 4, '2024-04-01'),
('Support Team', 5, '2024-05-01');

INSERT INTO GroupAccount (GroupID, AccountID, JoinDate) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-02-01'),
(3, 3, '2024-03-01'),
(4, 4, '2024-04-01'),
(5, 5, '2024-05-01');

INSERT INTO TypeQuestion (TypeName) VALUES
('Essay'),
('Multiple-Choice'),
('True/False'),
('Fill in the Blanks'),
('Matching');

INSERT INTO CategoryQuestion (CategoryName) VALUES
('Java'),
('.NET'),
('SQL'),
('Python'),
('Ruby');

INSERT INTO Question (Content, CategoryID, TypeID, CreatorID, CreateDate) VALUES
('What is Java?', 1, 1, 1, '2024-01-01'),
('Explain the .NET Framework', 2, 1, 2, '2024-02-01'),
('Write a SQL query to retrieve all employees', 3, 2, 3, '2024-03-01'),
('What is an API?', 4, 3, 4, '2024-04-01'),
('Explain Ruby’s object-oriented features', 5, 4, 5, '2024-05-01');

INSERT INTO Answer (Content, QuestionID, isCorrect) VALUES
('Java is a programming language', 1, 1),
('The .NET Framework is a software development platform', 2, 1),
('SELECT * FROM Employees', 3, 1),
('API stands for Application Programming Interface', 4, 1),
('Ruby supports classes and objects', 5, 1);

INSERT INTO Exam (Code, Title, CategoryID, Duration, CreatorID, CreateDate) VALUES
('EX001', 'Java Basics', 1, '01:00:00', 1, '2024-01-01'),
('EX002', 'Advanced .NET', 2, '01:30:00', 2, '2024-02-01'),
('EX003', 'SQL Querying', 3, '02:00:00', 3, '2024-03-01'),
('EX004', 'Python Basic', 4, '01:15:00', 4, '2024-04-01'),
('EX005', 'Ruby Fundamentals', 5, '01:00:00', 5, '2024-05-01');

INSERT INTO ExamQuestion (ExamID, QuestionID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


