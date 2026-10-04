USE TransportSpeditionDb;

BEGIN TRY
BEGIN TRANSACTION;

DECLARE @Responsibilities TABLE
(
    IncotermCode VARCHAR(3) NOT NULL,
    SubjectName NVARCHAR(100) NOT NULL,
    CostTypeCode VARCHAR(5) NOT NULL,
    AmountPercentage DECIMAL(5,2) NOT NULL,
    IsActive BIT NOT NULL
);

INSERT INTO @Responsibilities
(
    IncotermCode,
    SubjectName,
    CostTypeCode,
    AmountPercentage,
    IsActive
)
VALUES
    /*
        SALE    = Sale of Goods
        TRANS   = Transport
        CUST    = Customs Clearance
        INS     = Insurance
    */

    -- EXW
    ('EXW', N'Buyer',  'SALE', 100.00, 1),
    ('EXW', N'Seller', 'SALE',   0.00, 1),
    ('EXW', N'Buyer',  'TRANS', 100.00, 1),
    ('EXW', N'Seller', 'TRANS',   0.00, 1),
    ('EXW', N'Buyer',  'CUST', 100.00, 1),
    ('EXW', N'Seller', 'CUST',   0.00, 1),
    ('EXW', N'Buyer',  'INS',  100.00, 1),
    ('EXW', N'Seller', 'INS',    0.00, 1),

    -- FOB
    ('FOB', N'Buyer',  'SALE', 100.00, 1),
    ('FOB', N'Seller', 'SALE',   0.00, 1),
    ('FOB', N'Buyer',  'TRANS', 100.00, 1),
    ('FOB', N'Seller', 'TRANS',   0.00, 1),
    ('FOB', N'Buyer',  'CUST', 100.00, 1),
    ('FOB', N'Seller', 'CUST',   0.00, 1),
    ('FOB', N'Buyer',  'INS',  100.00, 1),
    ('FOB', N'Seller', 'INS',    0.00, 1),

    -- CIF
    ('CIF', N'Buyer',  'SALE', 100.00, 1),
    ('CIF', N'Seller', 'SALE',   0.00, 1),
    ('CIF', N'Seller', 'TRANS', 100.00, 1),
    ('CIF', N'Buyer',  'TRANS',   0.00, 1),
    ('CIF', N'Buyer',  'CUST', 100.00, 1),
    ('CIF', N'Seller', 'CUST',   0.00, 1),
    ('CIF', N'Seller', 'INS',  100.00, 1),
    ('CIF', N'Buyer',  'INS',    0.00, 1);


INSERT INTO IncotermCostResponsibilities
(
    IncotermRuleId,
    SubjectId,
    CostTypeId,
    AmountPercentage,
    IsActive
)
SELECT
     IncotermRules.Id
    ,Subjects.Id
    ,CostTypes.Id
    ,Responsibilities.AmountPercentage
    ,Responsibilities.IsActive

FROM @Responsibilities AS Responsibilities
INNER JOIN IncotermRules
    ON IncotermRules.IncotermCode = Responsibilities.IncotermCode
INNER JOIN Subjects
    ON Subjects.SubjectName = Responsibilities.SubjectName
INNER JOIN CostTypes
    ON CostTypes.TypeCode = Responsibilities.CostTypeCode
WHERE NOT EXISTS
(
    SELECT 1
    FROM IncotermCostResponsibilities
    WHERE 
        IncotermCostResponsibilities.IncotermRuleId = IncotermRules.Id
        AND IncotermCostResponsibilities.SubjectId = Subjects.Id
        AND IncotermCostResponsibilities.CostTypeId = CostTypes.Id
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
