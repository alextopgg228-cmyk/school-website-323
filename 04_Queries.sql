USE SchoolNadezhda;
GO

-- =============================================
-- 1. Сотрудники по должности
-- =============================================
SELECT
    e.EmployeeCode,
    e.FullName,
    e.Age,
    e.Gender,
    e.PhoneNumber,
    j.JobName,
    j.Salary
FROM dbo.Employees e
INNER JOIN dbo.Jobs j ON e.JobCode = j.JobCode
WHERE j.JobName = @JobName;   -- параметр: название должности
GO

-- =============================================
-- 2. Классы по году обучения
-- =============================================
SELECT
    c.ClassCode,
    c.ClassLetter,
    c.StudyYear,
    c.StudentCount,
    ct.TypeName,
    e.FullName AS ClassTeacher
FROM dbo.Classes c
INNER JOIN dbo.ClassTypes ct ON c.TypeCode = ct.TypeCode
INNER JOIN dbo.Employees  e  ON c.EmployeeCode = e.EmployeeCode
WHERE c.StudyYear = @StudyYear;
GO

-- =============================================
-- 3. Расписание конкретного класса на дату
-- =============================================
SELECT
    s.StartTime,
    s.EndTime,
    s.DayOfWeek,
    sub.SubjectName,
    e.FullName AS Teacher,
    s.RoomNumber
FROM dbo.Schedule s
INNER JOIN dbo.Classes  c   ON s.ClassCode   = c.ClassCode
INNER JOIN dbo.Subjects sub ON s.SubjectCode = sub.SubjectCode
INNER JOIN dbo.Employees e  ON sub.EmployeeCode = e.EmployeeCode
WHERE s.ClassCode    = @ClassCode
  AND s.ScheduleDate = @ScheduleDate
ORDER BY s.StartTime;
GO

-- =============================================
-- 4. Ученики конкретного класса
-- =============================================
SELECT
    s.StudentCode,
    s.FullName,
    s.BirthDate,
    s.Gender,
    s.FatherName,
    s.MotherName,
    s.AdditionalInfo,
    c.ClassLetter,
    c.StudyYear
FROM dbo.Students s
INNER JOIN dbo.Classes c ON s.ClassCode = c.ClassCode
WHERE s.ClassCode = @ClassCode
ORDER BY s.FullName;
GO

-- =============================================
-- 5. Предметы конкретного учителя
-- =============================================
SELECT
    sub.SubjectCode,
    sub.SubjectName,
    sub.Description,
    e.FullName AS TeacherName,
    j.JobName
FROM dbo.Subjects sub
INNER JOIN dbo.Employees e ON sub.EmployeeCode = e.EmployeeCode
INNER JOIN dbo.Jobs      j ON e.JobCode        = j.JobCode
WHERE sub.EmployeeCode = @EmployeeCode;
GO

-- =============================================
-- 6. Опубликованные новости (последние N)
-- =============================================
SELECT TOP 10
    n.NewsCode,
    n.Title,
    n.PublishDate,
    n.Content,
    e.FullName AS Author
FROM dbo.News n
LEFT JOIN dbo.Employees e ON n.AuthorCode = e.EmployeeCode
WHERE n.IsPublished = 1
ORDER BY n.PublishDate DESC;
GO

-- =============================================
-- 7. Список документов по категории
-- =============================================
SELECT
    d.DocumentCode,
    d.Title,
    d.Category,
    d.FilePath,
    d.UploadDate,
    d.Description
FROM dbo.Documents d
WHERE d.Category = @Category
ORDER BY d.UploadDate DESC;
GO

-- =============================================
-- 8. Аутентификация пользователя (проверка логина)
-- =============================================
SELECT
    u.UserCode,
    u.Login,
    u.PasswordHash,
    u.PasswordSalt,
    u.Role,
    u.FullName,
    u.Email,
    u.IsActive,
    e.EmployeeCode
FROM dbo.Users u
LEFT JOIN dbo.Employees e ON u.EmployeeCode = e.EmployeeCode
WHERE u.Login    = @Login
  AND u.IsActive = 1;
GO

-- =============================================
-- 9. Обновить дату последнего входа
-- =============================================
UPDATE dbo.Users
SET LastLoginDate = GETDATE()
WHERE UserCode = @UserCode;
GO

-- =============================================
-- 10. Классы с типом обучения
-- =============================================
SELECT
    c.ClassCode,
    CONCAT(c.StudyYear, ' «', c.ClassLetter, '»') AS ClassName,
    c.StudentCount,
    ct.TypeName,
    ct.Description,
    e.FullName AS ClassTeacher,
    e.PhoneNumber
FROM dbo.Classes c
INNER JOIN dbo.ClassTypes ct ON c.TypeCode     = ct.TypeCode
INNER JOIN dbo.Employees  e  ON c.EmployeeCode = e.EmployeeCode
WHERE ct.TypeCode = @TypeCode
ORDER BY c.StudyYear;
GO
