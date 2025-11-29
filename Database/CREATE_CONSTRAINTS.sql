USE ProjectManagement_DB;
GO

-- Foreign Keys (Зв'язки)
ALTER TABLE Employees ADD CONSTRAINT FK_Employees_Positions 
FOREIGN KEY (PositionID) REFERENCES Positions(PositionID);

ALTER TABLE Projects ADD CONSTRAINT FK_Projects_Customers 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

ALTER TABLE Projects ADD CONSTRAINT FK_Projects_Categories 
FOREIGN KEY (CategoryID) REFERENCES ProjectCategories(CategoryID);

ALTER TABLE WorkLogs ADD CONSTRAINT FK_WorkLogs_Projects 
FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID);

ALTER TABLE WorkLogs ADD CONSTRAINT FK_WorkLogs_Employees 
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

ALTER TABLE Invoices ADD CONSTRAINT FK_Invoices_Projects 
FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID);

ALTER TABLE Salaries ADD CONSTRAINT FK_Salaries_Employees 
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID);

-- Unique Constraints (Унікальність)
ALTER TABLE Positions ADD CONSTRAINT UQ_Positions_Name UNIQUE (PositionName);
ALTER TABLE ProjectCategories ADD CONSTRAINT UQ_Categories_Name UNIQUE (CategoryName);
ALTER TABLE Employees ADD CONSTRAINT UQ_Employees_Email UNIQUE (Email);

-- Check Constraints (Перевірки)
ALTER TABLE Positions ADD CONSTRAINT CK_Positions_Rate CHECK (BaseHourlyRate > 0);
ALTER TABLE Projects ADD CONSTRAINT CK_Projects_Status CHECK (Status IN ('Active', 'Completed', 'OnHold', 'Cancelled'));
ALTER TABLE Projects ADD CONSTRAINT CK_Projects_Dates CHECK (EndDate IS NULL OR EndDate >= StartDate);
ALTER TABLE WorkLogs ADD CONSTRAINT CK_WorkLogs_Hours CHECK (HoursWorked > 0 AND HoursWorked <= 24);
ALTER TABLE Invoices ADD CONSTRAINT CK_Invoices_Amount CHECK (Amount >= 0);
ALTER TABLE Salaries ADD CONSTRAINT CK_Salaries_Amount CHECK (TotalAmount >= 0);
ALTER TABLE Salaries ADD CONSTRAINT CK_Salaries_Month CHECK (Month BETWEEN 1 AND 12);
GO