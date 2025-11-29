USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ProjectManagement_DB')
BEGIN
    CREATE DATABASE ProjectManagement_DB;
END
GO