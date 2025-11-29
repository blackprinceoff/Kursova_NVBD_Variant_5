USE ProjectManagement_DB;
GO

-- 1. Positions
CREATE TABLE Positions (
    PositionID INT IDENTITY(1,1) NOT NULL,
    PositionName NVARCHAR(100) NOT NULL,
    BaseHourlyRate MONEY NOT NULL,
    CONSTRAINT PK_Positions PRIMARY KEY (PositionID)
);

-- 2. ProjectCategories
CREATE TABLE ProjectCategories (
    CategoryID INT IDENTITY(1,1) NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_ProjectCategories PRIMARY KEY (CategoryID)
);

-- 3. Employees
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NULL,
    Phone NVARCHAR(20) NULL,
    HireDate DATE NOT NULL,
    PositionID INT NOT NULL,
    CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID)
);

-- 4. Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) NOT NULL,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100) NULL,
    Email NVARCHAR(100) NULL,
    Phone NVARCHAR(20) NULL,
    Address NVARCHAR(255) NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (CustomerID)
);

-- 5. Projects
CREATE TABLE Projects (
    ProjectID INT IDENTITY(1,1) NOT NULL,
    ProjectName NVARCHAR(200) NOT NULL,
    CustomerID INT NOT NULL,
    CategoryID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Budget MONEY NULL,
    Status NVARCHAR(50) DEFAULT 'Active',
    CONSTRAINT PK_Projects PRIMARY KEY (ProjectID)
);

-- 6. WorkLogs
CREATE TABLE WorkLogs (
    LogID BIGINT IDENTITY(1,1) NOT NULL,
    ProjectID INT NOT NULL,
    EmployeeID INT NOT NULL,
    WorkDate DATE NOT NULL,
    HoursWorked DECIMAL(4, 2) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    HourlyRateApplied MONEY NOT NULL,
    CONSTRAINT PK_WorkLogs PRIMARY KEY (LogID)
);

-- 7. Invoices
CREATE TABLE Invoices (
    InvoiceID INT IDENTITY(1,1) NOT NULL,
    ProjectID INT NOT NULL,
    InvoiceDate DATE NOT NULL,
    Amount MONEY NOT NULL,
    IsPaid BIT DEFAULT 0,
    PaymentDate DATE NULL,
    CONSTRAINT PK_Invoices PRIMARY KEY (InvoiceID)
);

-- 8. Salaries
CREATE TABLE Salaries (
    SalaryID INT IDENTITY(1,1) NOT NULL,
    EmployeeID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Month INT NOT NULL,
    Year INT NOT NULL,
    TotalAmount MONEY NOT NULL,
    Bonus MONEY DEFAULT 0,
    CONSTRAINT PK_Salaries PRIMARY KEY (SalaryID)
);
GO