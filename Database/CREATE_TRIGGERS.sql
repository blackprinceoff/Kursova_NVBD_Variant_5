USE ProjectManagement_DB;
GO

CREATE OR ALTER TRIGGER TRG_PreventFutureWorkLogs
ON WorkLogs
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE WorkDate > GETDATE())
    BEGIN
        RAISERROR ('Помилка: Не можна вносити звіти про роботу майбутньою датою.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO