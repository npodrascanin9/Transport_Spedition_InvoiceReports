USE TransportSpeditionDb;

-- Fake data
DECLARE @Today DATETIME = GETDATE();

BEGIN TRY
BEGIN TRANSACTION

-- This record provides data for our own company
INSERT INTO Companies
(
    [Name],
    [Tin],
    [IdentificationNumber],
    [Country],
    [IsActive],
    [IsOurCompany],
    [CreatedAt],
    [UpdatedAt]
)
SELECT
    N'MyCompany d.o.o.', -- CompanyName
    '1994', -- Tin
    '25071994', -- IdentificationNumber
    N'Serbia',
    1, -- IsActive
    1, -- IsOurCompany
    @Today,-- CreatedAt
    @Today -- UpdatedAt
WHERE NOT EXISTS
(
    SELECT 1
    FROM Companies
    WHERE [IdentificationNumber] = '25071994'
);


INSERT INTO Companies
(
    [Name],
    [Tin],
    [IdentificationNumber],
    [Country],
    [IsActive],
    [IsOurCompany],
    [CreatedAt],
    [UpdatedAt]
)
SELECT
    N'Euro Transport d.o.o.',
    '104874725',
    '20258136',
    N'Serbia',
    1,
    0,
    @Today,
    @Today
WHERE NOT EXISTS
(
    SELECT 1
    FROM Companies
    WHERE [IdentificationNumber] = '20258136'
);

INSERT INTO Companies
(
    [Name],
    [Tin],
    [IdentificationNumber],
    [Country],
    [IsActive],
    [IsOurCompany],
    [CreatedAt],
    [UpdatedAt]
)
SELECT
    N'Adria Manufacturing d.o.o.',
    '100063973',
    '21341177',
    N'Serbia',
    1,
    0,
    @Today,
    @Today
WHERE NOT EXISTS
(
    SELECT 1
    FROM Companies
    WHERE [IdentificationNumber] = '21341177'
);

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
