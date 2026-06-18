USE SchoolNadezhda;
GO

-- =============================================
-- Внешние ключи
-- =============================================

-- Employees -> Jobs
ALTER TABLE dbo.Employees
    ADD CONSTRAINT FK_Employees_Jobs
    FOREIGN KEY (JobCode) REFERENCES dbo.Jobs(JobCode);

-- Classes -> Employees (классный руководитель)
ALTER TABLE dbo.Classes
    ADD CONSTRAINT FK_Classes_Employees
    FOREIGN KEY (EmployeeCode) REFERENCES dbo.Employees(EmployeeCode);

-- Classes -> ClassTypes
ALTER TABLE dbo.Classes
    ADD CONSTRAINT FK_Classes_ClassTypes
    FOREIGN KEY (TypeCode) REFERENCES dbo.ClassTypes(TypeCode);

-- Students -> Classes
ALTER TABLE dbo.Students
    ADD CONSTRAINT FK_Students_Classes
    FOREIGN KEY (ClassCode) REFERENCES dbo.Classes(ClassCode);

-- Subjects -> Employees (преподаватель)
ALTER TABLE dbo.Subjects
    ADD CONSTRAINT FK_Subjects_Employees
    FOREIGN KEY (EmployeeCode) REFERENCES dbo.Employees(EmployeeCode);

-- Schedule -> Classes
ALTER TABLE dbo.Schedule
    ADD CONSTRAINT FK_Schedule_Classes
    FOREIGN KEY (ClassCode) REFERENCES dbo.Classes(ClassCode);

-- Schedule -> Subjects
ALTER TABLE dbo.Schedule
    ADD CONSTRAINT FK_Schedule_Subjects
    FOREIGN KEY (SubjectCode) REFERENCES dbo.Subjects(SubjectCode);

-- News -> Employees (автор)
ALTER TABLE dbo.News
    ADD CONSTRAINT FK_News_Employees
    FOREIGN KEY (AuthorCode) REFERENCES dbo.Employees(EmployeeCode);

-- Users -> Employees (опциональная связь)
ALTER TABLE dbo.Users
    ADD CONSTRAINT FK_Users_Employees
    FOREIGN KEY (EmployeeCode) REFERENCES dbo.Employees(EmployeeCode);

PRINT 'Внешние ключи успешно созданы.';
GO
