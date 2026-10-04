USE TransportSpeditionDb;

DECLARE @Today DATETIME = GETDATE();

DECLARE @ExwIncotermRuleId INT;
DECLARE @CifIncotermRuleId INT;

SELECT @ExwIncotermRuleId = Id
FROM IncotermRules
WHERE IncotermCode = 'EXW';

SELECT @CifIncotermRuleId = Id
FROM IncotermRules
WHERE IncotermCode = 'CIF';

BEGIN TRY
BEGIN TRANSACTION;

IF NOT EXISTS
(
    SELECT 1
    FROM Invoices
    WHERE 
        InvoiceDate = '2026-10-01'
        AND DueDate = '2026-10-31'
        AND IncotermRuleId = @ExwIncotermRuleId
        AND Amount = 11500.00
        AND VatAmount = 2300.00
)
BEGIN
    INSERT INTO Invoices
    (
        InvoiceDate,
        DueDate,
        IncotermRuleId,
        Amount,
        VatAmount,
        CreatedAt,
        UpdatedAt
    )
    VALUES
    (
        '2026-10-01',
        '2026-10-31',
        @ExwIncotermRuleId,
        11500.00,
        2300.00,
        @Today,
        @Today
    );
END

IF NOT EXISTS
(
    SELECT 1
    FROM Invoices
    WHERE 
        InvoiceDate = '2026-10-02'
        AND DueDate = '2026-11-01'
        AND IncotermRuleId = @CifIncotermRuleId
        AND Amount = 23200.00
        AND VatAmount = 4640.00
)
BEGIN
    INSERT INTO Invoices
    (
        InvoiceDate,
        DueDate,
        IncotermRuleId,
        Amount,
        VatAmount,
        CreatedAt,
        UpdatedAt
    )
    VALUES
    (
        '2026-10-02',
        '2026-11-01',
        @CifIncotermRuleId,
        23200.00,
        4640.00,
        @Today,
        @Today
    );
END

COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @Message AS NVARCHAR(1000);

    SET @Message =
        'Transaction Rollbacked! Error at line '
        + CONVERT(NVARCHAR, ERROR_LINE())
        + ISNULL(' on procedure ' + ERROR_PROCEDURE(), '')
        + ': '
        + ERROR_MESSAGE();

    RAISERROR(@Message, 11, 1);
END CATCH;
