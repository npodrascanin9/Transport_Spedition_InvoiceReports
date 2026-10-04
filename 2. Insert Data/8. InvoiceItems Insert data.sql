-- InvoiceItems insert data
DECLARE @ExwIncotermRuleId INT;
DECLARE @CifIncotermRuleId INT;

SELECT @ExwIncotermRuleId = Id
FROM IncotermRules
WHERE IncotermCode = 'EXW';

SELECT @CifIncotermRuleId = Id
FROM IncotermRules
WHERE IncotermCode = 'CIF';

DECLARE @SaleOfGoodsCostTypeId INT;
DECLARE @TransportCostTypeId INT;
DECLARE @CustomsClearanceCostTypeId INT;
DECLARE @InsuranceCostTypeId INT;

SELECT @SaleOfGoodsCostTypeId = Id
FROM CostTypes
WHERE TypeCode = 'SALE';

SELECT @TransportCostTypeId = Id
FROM CostTypes
WHERE TypeCode = 'TRANS';

SELECT @CustomsClearanceCostTypeId = Id
FROM CostTypes
WHERE TypeCode = 'CUST';

SELECT @InsuranceCostTypeId = Id
FROM CostTypes
WHERE TypeCode = 'INS';

DECLARE @ExwInvoiceId AS INT;
DECLARE @CifInvoiceId AS INT;

SELECT @ExwInvoiceId = Id
FROM Invoices
WHERE IncotermRuleId = @ExwIncotermRuleId;

SELECT @CifInvoiceId = Id
FROM Invoices
WHERE IncotermRuleId = @CifIncotermRuleId;


BEGIN TRY
BEGIN TRANSACTION

-- EXW invoice - Transport
IF NOT EXISTS
(
    SELECT 1
    FROM InvoiceItems
    WHERE InvoiceId = @ExwInvoiceId
      AND CostTypeId = @TransportCostTypeId
)
BEGIN
    INSERT INTO InvoiceItems
    (
        InvoiceId,
        CostTypeId,
        Amount,
        VatAmount
    )
    VALUES
    (
        @ExwInvoiceId,
        @TransportCostTypeId,
        1200.00,
        240.00
    );
END;

-- EXW invoice - Customs Clearance
IF NOT EXISTS
(
    SELECT 1
    FROM InvoiceItems
    WHERE InvoiceId = @ExwInvoiceId
      AND CostTypeId = @CustomsClearanceCostTypeId
)
BEGIN
    INSERT INTO InvoiceItems
    (
        InvoiceId,
        CostTypeId,
        Amount,
        VatAmount
    )
    VALUES
    (
        @ExwInvoiceId,
        @CustomsClearanceCostTypeId,
        300.00,
        60.00
    );
END;

-- CIF invoice - Sale of Goods
IF NOT EXISTS
(
    SELECT 1
    FROM InvoiceItems
    WHERE InvoiceId = @CifInvoiceId
      AND CostTypeId = @SaleOfGoodsCostTypeId
)
BEGIN
    INSERT INTO InvoiceItems
    (
        InvoiceId,
        CostTypeId,
        Amount,
        VatAmount
    )
    VALUES
    (
        @CifInvoiceId,
        @SaleOfGoodsCostTypeId,
        20000.00,
        4000.00
    );
END;

-- CIF invoice - Transport
IF NOT EXISTS
(
    SELECT 1
    FROM InvoiceItems
    WHERE InvoiceId = @CifInvoiceId
      AND CostTypeId = @TransportCostTypeId
)
BEGIN
    INSERT INTO InvoiceItems
    (
        InvoiceId,
        CostTypeId,
        Amount,
        VatAmount
    )
    VALUES
    (
        @CifInvoiceId,
        @TransportCostTypeId,
        2500.00,
        500.00
    );
END;

-- CIF invoice - Customs Clearance
IF NOT EXISTS
(
    SELECT 1
    FROM InvoiceItems
    WHERE InvoiceId = @CifInvoiceId
      AND CostTypeId = @CustomsClearanceCostTypeId
)
BEGIN
    INSERT INTO InvoiceItems
    (
        InvoiceId,
        CostTypeId,
        Amount,
        VatAmount
    )
    VALUES
    (
        @CifInvoiceId,
        @CustomsClearanceCostTypeId,
        500.00,
        100.00
    );
END;

-- CIF invoice - Insurance
IF NOT EXISTS
(
    SELECT 1
    FROM InvoiceItems
    WHERE InvoiceId = @CifInvoiceId
      AND CostTypeId = @InsuranceCostTypeId
)
BEGIN
    INSERT INTO InvoiceItems
    (
        InvoiceId,
        CostTypeId,
        Amount,
        VatAmount
    )
    VALUES
    (
        @CifInvoiceId,
        @InsuranceCostTypeId,
        200.00,
        40.00
    );
END;



COMMIT TRANSACTION
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
