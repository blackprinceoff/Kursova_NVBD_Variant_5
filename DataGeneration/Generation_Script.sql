USE ProjectManagement_DB;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON; 

PRINT '>>> STARTING DATA GENERATION PROCESS...';

-- 1. DISABLE CONSTRAINTS
PRINT '>>> Disabling constraints...';
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";
GO

-- 2. CLEANUP
PRINT '>>> Cleaning tables...';
DELETE FROM WorkLogs;
DELETE FROM Invoices;
DELETE FROM Salaries;
DELETE FROM Projects;
DELETE FROM Employees;
DELETE FROM Customers;
DELETE FROM Positions;
DELETE FROM ProjectCategories;

-- 3. RESET IDENTITIES
DBCC CHECKIDENT ('WorkLogs', RESEED, 0);
DBCC CHECKIDENT ('Invoices', RESEED, 0);
DBCC CHECKIDENT ('Salaries', RESEED, 0);
DBCC CHECKIDENT ('Projects', RESEED, 0);
DBCC CHECKIDENT ('Employees', RESEED, 0);
DBCC CHECKIDENT ('Customers', RESEED, 0);
DBCC CHECKIDENT ('Positions', RESEED, 0);
DBCC CHECKIDENT ('ProjectCategories', RESEED, 0);

-- 4. DATA GENERATION

-- --- DICTIONARIES ---
PRINT '>>> Generating Dictionaries...';
INSERT INTO Positions (PositionName, BaseHourlyRate) VALUES 
('Junior Developer', 15), ('Middle Developer', 25), ('Senior Developer', 45),
('QA Engineer', 20), ('Project Manager', 40), ('Business Analyst', 35), ('DevOps Engineer', 50),
('UI/UX Designer', 30), ('Architect', 60), ('Team Lead', 55);

INSERT INTO ProjectCategories (CategoryName) VALUES 
('Web Development'), ('Mobile App'), ('Desktop Application'), ('Cloud Migration'), 
('Consulting'), ('Cybersecurity Audit'), ('Data Science'), ('IoT Integration'), 
('Legacy Support'), ('E-commerce');

-- --- EMPLOYEES ---
PRINT '>>> Generating Employees (2000)...';
DECLARE @i INT = 1;
BEGIN TRANSACTION;
WHILE @i <= 2000
BEGIN
    INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, PositionID)
    VALUES (
        'EmpName_' + CAST(@i AS VARCHAR), 
        'EmpLast_' + CAST(@i AS VARCHAR),
        'user' + CAST(@i AS VARCHAR) + '@company.com',
        '050' + RIGHT('0000000' + CAST(@i AS VARCHAR), 7),
        DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1825), GETDATE()), 
        (ABS(CHECKSUM(NEWID())) % 10) + 1 
    );
    SET @i = @i + 1;
END
COMMIT TRANSACTION;

-- --- CUSTOMERS ---
PRINT '>>> Generating Customers (1000)...';
SET @i = 1;
BEGIN TRANSACTION;
WHILE @i <= 1000
BEGIN
    INSERT INTO Customers (CompanyName, ContactPerson, Email, Phone, Address)
    VALUES (
        'Customer_Co_' + CAST(@i AS VARCHAR),
        'Contact_' + CAST(@i AS VARCHAR),
        'client' + CAST(@i AS VARCHAR) + '@b2b.com',
        '067' + RIGHT('0000000' + CAST(@i AS VARCHAR), 7),
        'Business Address Str. ' + CAST(@i AS VARCHAR)
    );
    SET @i = @i + 1;
END
COMMIT TRANSACTION;

-- --- PROJECTS ---
PRINT '>>> Generating Projects (5500)...';
SET @i = 1;
BEGIN TRANSACTION;
WHILE @i <= 5500
BEGIN
    INSERT INTO Projects (ProjectName, CustomerID, CategoryID, StartDate, EndDate, Budget, Status)
    VALUES (
        'Project #' + CAST(@i AS VARCHAR),
        (ABS(CHECKSUM(NEWID())) % 1000) + 1, 
        (ABS(CHECKSUM(NEWID())) % 10) + 1,   
        DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1825), GETDATE()),
        NULL, 
        ABS(CHECKSUM(NEWID()) % 200000) + 5000,
        CASE WHEN ABS(CHECKSUM(NEWID()) % 10) < 7 THEN 'Completed' ELSE 'Active' END
    );
    SET @i = @i + 1;
END
COMMIT TRANSACTION;

-- Fix Dates for Projects
UPDATE Projects SET EndDate = DATEADD(DAY, 30 + (ABS(CHECKSUM(NEWID())) % 300), StartDate);

-- --- SALARIES ---
PRINT '>>> Generating Salaries (>100,000)...';
-- Generating monthly salaries for 5 years history
INSERT INTO Salaries (EmployeeID, PaymentDate, Month, Year, TotalAmount, Bonus)
SELECT 
    e.EmployeeID,
    DATEFROMPARTS(y.YearNum, m.MonthNum, 28),
    m.MonthNum,
    y.YearNum,
    p.BaseHourlyRate * 160,
    CASE WHEN (ABS(CHECKSUM(NEWID())) % 10) > 8 THEN 500 ELSE 0 END
FROM Employees e
JOIN Positions p ON e.PositionID = p.PositionID
CROSS JOIN (VALUES (2020),(2021),(2022),(2023),(2024)) AS y(YearNum)
CROSS JOIN (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) AS m(MonthNum);

-- --- INVOICES ---
PRINT '>>> Generating Invoices...';
INSERT INTO Invoices (ProjectID, InvoiceDate, Amount, IsPaid, PaymentDate)
SELECT TOP 10000 
    ProjectID, StartDate, Budget/2, 1, EndDate
FROM Projects;

-- --- WORKLOGS ---
PRINT '>>> Generating WorkLogs (550,000)...';
SET @i = 1;
BEGIN TRANSACTION;
WHILE @i <= 550000
BEGIN
    INSERT INTO WorkLogs (ProjectID, EmployeeID, WorkDate, HoursWorked, Description, HourlyRateApplied)
    VALUES (
        (ABS(CHECKSUM(NEWID())) % 5500) + 1, 
        (ABS(CHECKSUM(NEWID())) % 2000) + 1, 
        DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1000), GETDATE()),
        (ABS(CHECKSUM(NEWID())) % 8) + 1,
        'Log #' + CAST(@i AS VARCHAR),
        25
    );
    
    IF @i % 5000 = 0 
    BEGIN 
        COMMIT TRANSACTION; 
        BEGIN TRANSACTION; 
    END
    SET @i = @i + 1;
END
COMMIT TRANSACTION;

-- 5. ENABLE CONSTRAINTS
PRINT '>>> Re-enabling constraints...';
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all";
GO

PRINT '>>> DATA GENERATION COMPLETED SUCCESSFULLY.';