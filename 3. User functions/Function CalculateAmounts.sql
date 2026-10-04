CREATE OR ALTER FUNCTION CalculateAmounts
(
    @AmountPercentage DECIMAL(18, 2),
    @InvoiceItemAmount DECIMAL(18, 2),
    @InvoiceItemVatAmount DECIMAL(18, 2)
)
RETURNS @AmountsTable TABLE
(
    Amount DECIMAL(18, 2),
    VatAmount DECIMAL(18, 2),
    TotalAmount DECIMAL(18, 2)
)
AS
BEGIN
    DECLARE @Amount DECIMAL(18, 2) 
        = @InvoiceItemAmount * (@AmountPercentage / 100);

    DECLARE @VatAmount DECIMAL(18, 2) 
        = @InvoiceItemVatAmount * (@AmountPercentage / 100);
    
    DECLARE @TotalAmount DECIMAL(18, 2) 
        = @Amount + @VatAmount;

    INSERT INTO @AmountsTable 
    (
        Amount, 
        VatAmount, 
        TotalAmount
    )
    VALUES 
    (
        @Amount, 
        @VatAmount, 
        @TotalAmount
    );

    RETURN;
END
