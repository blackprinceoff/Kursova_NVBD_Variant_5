USE ProjectManagement_DB;
GO

CREATE OR ALTER PROCEDURE GetProjectBudgetStatus
    @ProjectID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProjectName,
        p.Budget AS PlannedBudget,
        ISNULL(SUM(wl.HoursWorked * wl.HourlyRateApplied), 0) AS SpentBudget,
        (p.Budget - ISNULL(SUM(wl.HoursWorked * wl.HourlyRateApplied), 0)) AS RemainingBudget
    FROM Projects p
    LEFT JOIN WorkLogs wl ON p.ProjectID = wl.ProjectID
    WHERE p.ProjectID = @ProjectID
    GROUP BY p.ProjectName, p.Budget;
END;
GO