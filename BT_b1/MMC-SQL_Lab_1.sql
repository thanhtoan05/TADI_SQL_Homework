CREATE DATABASE IF NOT EXISTS Testing_System_Db ;
USE Testing_System_Db ;

CREATE TABLE Department (
    DepartmentID    TINYINT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName      NVARCHAR(30) NOT NULL
);

CREATE TABLE `Position` (
    PositionID      TINYINT AUTO_INCREMENT PRIMARY KEY,
    PositionName    NVARCHAR(30) NOT NULL
);
CREATE TABLE Account (
    AccountID MEDIUMINT     AUTO_INCREMENT PRIMARY KEY,
    Email   NVARCHAR(30) NOT NULL,
    Username    NVARCHAR(30) NOT NULL,
    FullName    NVARCHAR(30) NOT NULL,
    DepartmentID    TINYINT,
    PositionID   TINYINT,
    CreateDate      DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (PositionID) REFERENCES `Position`(PositionID)
);

CREATE TABLE `Group` (
    GroupID     TINYINT AUTO_INCREMENT PRIMARY KEY,
    GroupName       NVARCHAR(30) NOT NULL,
    CreatorID       MEDIUMINT NOT NULL,
    CreateDate      DATE NOT NULL,
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)
);

CREATE TABLE GroupAccount (
    GroupID     TINYINT,
    AccountID   MEDIUMINT NOT NULL,
    JoinDate    DATE NOT NULL,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE TypeQuestion (
    TypeID      TINYINT AUTO_INCREMENT PRIMARY KEY,
    TypeName    NVARCHAR(30) NOT NULL    
);

CREATE TABLE CategoryQuestion (
    CategoryID      TINYINT AUTO_INCREMENT PRIMARY KEY,
    CategoryName    NVARCHAR(30) NOT NULL
);

CREATE TABLE Question(
    QuestionID  SMALLINT AUTO_INCREMENT PRIMARY KEY,
    Content     NVARCHAR(100) NOT NULL,
    CategoryID  TINYINT NOT NULL,
    TypeID      TINYINT NOT NULL,
    CreatorID MEDIUMINT     NOT NULL,
    CreateDate      DATE,
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY (TypeID) REFERENCES TypeQuestion(TypeID),
    FOREIGN KEY (CreatorID) REFERENCES Account(AccountID)    
);

CREATE TABLE Answer ( 
    AnswerID    SMALLINT AUTO_INCREMENT PRIMARY KEY,
    Content     NVARCHAR(100) NOT NULL,
    QuestionID      SMALLINT NOT NULL,
    isCorrect       ENUM('True', 'False'),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);

CREATE TABLE Exam (
    ExamID      TINYINT AUTO_INCREMENT PRIMARY KEY,
    Code    NVARCHAR(10) NOT NULL,
    Title   NVARCHAR(30) NOT NULL,
    CategoryID  TINYINT,
    Duration    TIME NOT NULL,
    CreatorID       MEDIUMINT NOT NULL,
    CreateDate   DATE NOT NULL
);

CREATE TABLE ExamQuestion (
    ExamID  TINYINT,
    QuestionID  SMALLINT,
    FOREIGN KEY (ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)
);

