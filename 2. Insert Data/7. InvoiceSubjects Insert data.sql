-- InvoiceSubjects table insert data

DECLARE @ExwIncotermRuleId AS INT;
DECLARE @CifIncotermRuleId AS INT;

SELECT
    @ExwIncotermRuleId =
        MAX
        (
            CASE
                WHEN IncotermCode = 'EXW'
                THEN Id
            END
        ),
    @CifIncotermRuleId =
        MAX
        (
            CASE
                WHEN IncotermCode = 'CIF'
                THEN Id
            END
        )
FROM IncotermRules;

-- IncotermRules
-- =====================


-- =====================
-- Invoices

DECLARE @ExwInvoiceId AS INT;
DECLARE @CifInvoiceId AS INT;

SELECT
    @ExwInvoiceId =
        MAX
        (
            CASE
                WHEN IncotermRuleId = @ExwIncotermRuleId
                THEN Id
            END
        ),
    @CifInvoiceId =
        MAX
        (
            CASE
                WHEN IncotermRuleId = @CifIncotermRuleId
                THEN Id
            END
        )
FROM Invoices;

-- Invoices
-- =====================


-- =====================
-- Subjects

DECLARE @BuyerSubjectId AS INT;
DECLARE @SellerSubjectId AS INT;

SELECT
    @BuyerSubjectId =
        MAX
        (
            CASE
                WHEN SubjectName = N'Buyer'
                THEN Id
            END
        ),
    @SellerSubjectId =
        MAX
        (
            CASE
                WHEN SubjectName = N'Seller'
                THEN Id
            END
        )
FROM Subjects;

-- Subjects
-- =====================


-- =====================
-- Companies

DECLARE @MyCompanyId AS INT;
DECLARE @EuroTransportCompanyId AS INT;
DECLARE @AdriaManufacturingCompanyId AS INT;

SELECT
    @MyCompanyId =
        MAX
        (
            CASE
                WHEN IdentificationNumber = '25071994'
                THEN Id
            END
        ),
    @EuroTransportCompanyId =
        MAX
        (
            CASE
                WHEN IdentificationNumber = '20258136'
                THEN Id
            END
        ),
    @AdriaManufacturingCompanyId =
        MAX
        (
            CASE
                WHEN IdentificationNumber = '21341177'
                THEN Id
            END
        )
FROM Companies;

-- Companies
-- =====================


BEGIN TRY
BEGIN TRANSACTION;

-- Required data validation
IF @ExwIncotermRuleId IS NULL
    THROW 50001, 'EXW Incoterm rule was not found.', 1;

IF @CifIncotermRuleId IS NULL
    THROW 50002, 'CIF Incoterm rule was not found.', 1;

IF @ExwInvoiceId IS NULL
    THROW 50003, 'EXW invoice was not found.', 1;

IF @CifInvoiceId IS NULL
    THROW 50004, 'CIF invoice was not found.', 1;

IF @BuyerSubjectId IS NULL
    THROW 50005, 'Buyer subject was not found.', 1;

IF @SellerSubjectId IS NULL
    THROW 50006, 'Seller subject was not found.', 1;

IF @MyCompanyId IS NULL
    THROW 50007, 'My company was not found.', 1;

IF @EuroTransportCompanyId IS NULL
    THROW 50008, 'Euro Transport company was not found.', 1;

IF @AdriaManufacturingCompanyId IS NULL
    THROW 50009, 'Adria Manufacturing company was not found.', 1;


/*
    InvoiceSubjects seed data

    EXW invoice:
    - MyCompany is the Seller
    - Adria Manufacturing is the Buyer

    CIF invoice:
    - MyCompany is the Seller
    - Euro Transport is the Buyer
*/
INSERT INTO InvoiceSubjects
(
    InvoiceId,
    CompanyId,
    SubjectId
)
SELECT
    InvoiceSubjectSeed.InvoiceId,
    InvoiceSubjectSeed.CompanyId,
    InvoiceSubjectSeed.SubjectId
FROM
(
    VALUES
        (
            @ExwInvoiceId,
            @MyCompanyId,
            @SellerSubjectId
        ),
        (
            @ExwInvoiceId,
            @AdriaManufacturingCompanyId,
            @BuyerSubjectId
        ),
        (
            @CifInvoiceId,
            @MyCompanyId,
            @SellerSubjectId
        ),
        (
            @CifInvoiceId,
            @EuroTransportCompanyId,
            @BuyerSubjectId
        )
) AS InvoiceSubjectSeed
(
    InvoiceId,
    CompanyId,
    SubjectId
)
WHERE NOT EXISTS
(
    SELECT 1
    FROM InvoiceSubjects
    WHERE 
        InvoiceSubjects.InvoiceId = InvoiceSubjectSeed.InvoiceId
        AND InvoiceSubjects.CompanyId = InvoiceSubjectSeed.CompanyId
        AND InvoiceSubjects.SubjectId = InvoiceSubjectSeed.SubjectId
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
END CATCH;
