USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ProjectManagement_DW')
BEGIN
    CREATE DATABASE ProjectManagement_DW;
END
GO

USE ProjectManagement_DW;
GO

-- DIMENSION TABLES 

-- 1. DimDate
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month INT,
    MonthName NVARCHAR(20),
    Quarter INT,
    DayOfWeekName NVARCHAR(20),
    IsWeekend BIT
);

-- 2. DimEmployee (SCD Type 2 support)
CREATE TABLE DimEmployee (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID_Source INT,
    FullName NVARCHAR(100),
    PositionName NVARCHAR(100),
    Email NVARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    IsCurrent BIT
);

-- 3. DimProject
CREATE TABLE DimProject (
    ProjectKey INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID_Source INT,
    ProjectName NVARCHAR(200),
    CategoryName NVARCHAR(100),
    Status NVARCHAR(50),
    Budget MONEY,
    StartDate DATE,
    EndDate DATE
);

-- 4. DimCustomer
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID_Source INT,
    CompanyName NVARCHAR(100),
    ContactPerson NVARCHAR(100),
    City NVARCHAR(100)
);

-- 5. DimCategory
CREATE TABLE DimCategory (
    CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID_Source INT,
    CategoryName NVARCHAR(100)
);

-- FACT TABLES

-- 1. FactWorkLogs
CREATE TABLE FactWorkLogs (
    FactLogKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeKey INT FOREIGN KEY REFERENCES DimEmployee(EmployeeKey),
    ProjectKey INT FOREIGN KEY REFERENCES DimProject(ProjectKey),
    DateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    HoursWorked DECIMAL(4, 2),
    LaborCost MONEY,
    RecordCount INT DEFAULT 1
);

-- 2. FactInvoices
CREATE TABLE FactInvoices (
    FactInvoiceKey INT IDENTITY(1,1) PRIMARY KEY,
    ProjectKey INT FOREIGN KEY REFERENCES DimProject(ProjectKey),
    CustomerKey INT FOREIGN KEY REFERENCES DimCustomer(CustomerKey),
    DateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    InvoiceAmount MONEY,
    IsPaid BIT,
    PaymentDelayDays INT
);
GO