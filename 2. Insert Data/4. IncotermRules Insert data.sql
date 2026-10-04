USE TransportSpeditionDb;

-- Although there are 13 Incoterms,
-- this portfolio project uses only three:
-- EXW, FOB and CIF.
BEGIN TRY
BEGIN TRANSACTION

IF NOT EXISTS
(
    SELECT 1
    FROM IncotermRules
    WHERE IncotermCode = 'EXW'
)
BEGIN
    INSERT INTO IncotermRules
    (
        IncotermCode,
        RuleTitle,
        Description,
        IsActive
    )
    VALUES
    (
        'EXW',
        'Ex Works',
        N'The buyer assumes most transport, customs clearance and insurance-related costs from the seller''s premises.',
        1
    );
END

IF NOT EXISTS
(
    SELECT 1
    FROM IncotermRules
    WHERE IncotermCode = 'FOB'
)
BEGIN
    INSERT INTO IncotermRules
    (
        IncotermCode,
        RuleTitle,
        Description,
        IsActive
    )
    VALUES
    (
        'FOB',
        'Free On Board',
        N'The seller is responsible for export-related costs and delivery to the port, while the buyer assumes the main transport, insurance and import-related costs.',
        1
    );
END

IF NOT EXISTS
(
    SELECT 1
    FROM IncotermRules
    WHERE IncotermCode = 'CIF'
)
BEGIN
    INSERT INTO IncotermRules
    (
        IncotermCode,
        RuleTitle,
        Description,
        IsActive
    )
    VALUES
    (
        'CIF',
        'Cost, Insurance and Freight',
        N'The seller is responsible for the main transport and insurance, while the buyer assumes import-related costs.',
        1
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
END CATCH
