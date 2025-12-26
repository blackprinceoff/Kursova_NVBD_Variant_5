USE ProjectManagement_DW;
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('DimDate') AND name = 'FullDate' AND system_type_id = 40) -- 40 = date
BEGIN
    TRUNCATE TABLE DimDate;
    ALTER TABLE DimDate ALTER COLUMN FullDate DATETIME;
    PRINT 'Column FullDate changed to DATETIME';
END
GO

SET NOCOUNT ON;
DELETE FROM DimDate;

DECLARE @StartDate DATETIME = '2020-01-01 00:00:00';
DECLARE @EndDate DATETIME = '2030-12-31 00:00:00';

PRINT 'Generating Calendar...';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (
        DateKey, 
        FullDate, 
        Year, 
        Month, 
        MonthName, 
        Quarter, 
        DayOfWeekName, 
        IsWeekend
    )
    VALUES (
        -- Ключ у форматі YYYYMMDD
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT), 
        @StartDate,
        YEAR(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(QUARTER, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        -- 1 = Неділя, 7 = Субота
        CASE WHEN DATENAME(WEEKDAY, @StartDate) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END

PRINT 'DimDate populated successfully!';
GO