USE master;
GO

-- Создание базы данных
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SchoolNadezhda')
    CREATE DATABASE SchoolNadezhda;
GO

USE SchoolNadezhda;
GO

-- =============================================
-- Таблица должностей/ставок
-- =============================================
CREATE TABLE dbo.Jobs
(
    JobCode         BIGINT IDENTITY(1,1) CONSTRAINT PK_Jobs PRIMARY KEY,
    JobName         NVARCHAR(100) NOT NULL,
    Salary          MONEY         NOT NULL,
    Responsibilities NVARCHAR(1000) NULL,
    Requirements    NVARCHAR(500)  NOT NULL
);
GO

-- =============================================
-- Типы классов
-- =============================================
CREATE TABLE dbo.ClassTypes
(
    TypeCode    BIGINT IDENTITY(1,1) CONSTRAINT PK_ClassTypes PRIMARY KEY,
    TypeName    NVARCHAR(100)  NOT NULL,
    Description NVARCHAR(500)  NULL
);
GO

-- =============================================
-- Сотрудники (педагоги и администрация)
-- =============================================
CREATE TABLE dbo.Employees
(
    EmployeeCode BIGINT IDENTITY(1,1) CONSTRAINT PK_Employees PRIMARY KEY,
    FullName     NVARCHAR(200) NOT NULL,
    Age          TINYINT       NOT NULL,
    Gender       CHAR(1)       NOT NULL CHECK (Gender IN ('М','Ж')),
    Address      NVARCHAR(500) NOT NULL,
    PhoneNumber  NVARCHAR(30)  NOT NULL,
    PassportData NVARCHAR(100) NOT NULL,
    JobCode      BIGINT        NOT NULL,
    PhotoPath    NVARCHAR(500) NULL,
    Bio          NVARCHAR(2000) NULL
);
GO

-- =============================================
-- Классы
-- =============================================
CREATE TABLE dbo.Classes
(
    ClassCode    BIGINT IDENTITY(1,1) CONSTRAINT PK_Classes PRIMARY KEY,
    EmployeeCode BIGINT  NOT NULL,   -- классный руководитель
    TypeCode     BIGINT  NOT NULL,
    StudentCount INT     NOT NULL DEFAULT 0,
    ClassLetter  NCHAR(1) NOT NULL,
    StudyYear    INT     NOT NULL,
    CreationYear INT     NOT NULL
);
GO

-- =============================================
-- Ученики
-- =============================================
CREATE TABLE dbo.Students
(
    StudentCode    BIGINT IDENTITY(1,1) CONSTRAINT PK_Students PRIMARY KEY,
    FullName       NVARCHAR(200) NOT NULL,
    BirthDate      DATE          NOT NULL,
    Gender         CHAR(1)       NOT NULL CHECK (Gender IN ('М','Ж')),
    Address        NVARCHAR(500) NOT NULL,
    FatherName     NVARCHAR(200) NULL,
    MotherName     NVARCHAR(200) NULL,
    ClassCode      BIGINT        NOT NULL,
    AdditionalInfo NVARCHAR(1000) NULL
);
GO

-- =============================================
-- Предметы
-- =============================================
CREATE TABLE dbo.Subjects
(
    SubjectCode  BIGINT IDENTITY(1,1) CONSTRAINT PK_Subjects PRIMARY KEY,
    SubjectName  NVARCHAR(100)  NOT NULL,
    Description  NVARCHAR(500)  NULL,
    EmployeeCode BIGINT         NOT NULL   -- преподаватель
);
GO

-- =============================================
-- Расписание
-- =============================================
CREATE TABLE dbo.Schedule
(
    ScheduleCode BIGINT IDENTITY(1,1) CONSTRAINT PK_Schedule PRIMARY KEY,
    ScheduleDate DATE         NOT NULL,
    DayOfWeek    NVARCHAR(20) NOT NULL,
    ClassCode    BIGINT       NOT NULL,
    SubjectCode  BIGINT       NOT NULL,
    StartTime    TIME         NOT NULL,
    EndTime      TIME         NOT NULL,
    RoomNumber   NVARCHAR(20) NULL
);
GO

-- =============================================
-- Новости
-- =============================================
CREATE TABLE dbo.News
(
    NewsCode    BIGINT IDENTITY(1,1) CONSTRAINT PK_News PRIMARY KEY,
    Title       NVARCHAR(500)  NOT NULL,
    Content     NVARCHAR(MAX)  NOT NULL,
    PublishDate DATE           NOT NULL DEFAULT GETDATE(),
    ImagePath   NVARCHAR(500)  NULL,
    IsPublished BIT            NOT NULL DEFAULT 1,
    AuthorCode  BIGINT         NULL   -- EmployeeCode автора
);
GO

-- =============================================
-- Документы (нормативная база)
-- =============================================
CREATE TABLE dbo.Documents
(
    DocumentCode BIGINT IDENTITY(1,1) CONSTRAINT PK_Documents PRIMARY KEY,
    Title        NVARCHAR(500) NOT NULL,
    Category     NVARCHAR(100) NOT NULL,
    FilePath     NVARCHAR(500) NOT NULL,
    UploadDate   DATE          NOT NULL DEFAULT GETDATE(),
    Description  NVARCHAR(500) NULL
);
GO

-- =============================================
-- Горячие линии
-- =============================================
CREATE TABLE dbo.HotLines
(
    HotLineCode BIGINT IDENTITY(1,1) CONSTRAINT PK_HotLines PRIMARY KEY,
    Topic       NVARCHAR(300) NOT NULL,
    PhoneNumber NVARCHAR(50)  NOT NULL,
    SortOrder   INT           NOT NULL DEFAULT 0
);
GO

-- =============================================
-- Пользователи (авторизация на сайте)
-- =============================================
CREATE TABLE dbo.Users
(
    UserCode      BIGINT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    Login         NVARCHAR(100) NOT NULL CONSTRAINT UQ_Users_Login UNIQUE,
    PasswordHash  NVARCHAR(256) NOT NULL,  -- SHA-256 хэш
    PasswordSalt  NVARCHAR(100) NOT NULL,
    Role          NVARCHAR(20)  NOT NULL DEFAULT 'user'
                      CHECK (Role IN ('admin','teacher','user')),
    FullName      NVARCHAR(200) NOT NULL,
    Email         NVARCHAR(200) NULL,
    EmployeeCode  BIGINT        NULL,      -- связь с сотрудником (если есть)
    IsActive      BIT           NOT NULL DEFAULT 1,
    CreatedDate   DATETIME      NOT NULL DEFAULT GETDATE(),
    LastLoginDate DATETIME      NULL
);
GO

PRINT 'Таблицы успешно созданы.';
GO
