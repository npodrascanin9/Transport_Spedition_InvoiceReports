USE TransportSpeditionDb;

GO

CREATE OR ALTER PROC spGetInvoiceReportById_v1
	@Id INT
AS

IF NOT EXISTS
(
	SELECT 1
	FROM Invoices
	WHERE Id = @Id
)
BEGIN
	RAISERROR ('Invoice with Id=%d not found', 11, 1, @Id);
	RETURN;
END

-- 1st data result-set: Invoice Details
SELECT
	 Invoices.Id
	,Invoices.InvoiceDate
	,Invoices.Amount
	,Invoices.VatAmount
	,Invoices.TotalAmount
	,Invoices.CreatedAt
	,Invoices.UpdatedAt
	,Invoices.CompanyId -- in version 1, CompanyId is used within the Invoices table
	,Companies.Name
		AS CompanyName
	,Companies.IdentificationNumber
	,Companies.Tin
		AS CompanyTin
	,Companies.Country

FROM Invoices
INNER JOIN Companies
	ON Companies.Id = Invoices.CompanyId
WHERE 
	Invoices.Id = @Id;

-- 2nd data result-set: Invoice Items
SELECT
	 InvoiceItems.Id
	,InvoiceItems.InvoiceId
	,InvoiceItems.CostTypeId
	,CostTypes.TypeCode
		AS CostTypeCode
	,CostTypes.Type
		AS CostType
	,CostTypes.Description
		AS CostTypeDescription
	,InvoiceItems.Amount
	,InvoiceItems.VatAmount
	,InvoiceItems.TotalAmount

FROM InvoiceItems
INNER JOIN CostTypes
	ON CostTypes.Id = InvoiceItems.CostTypeId
	AND CostTypes.IsActive = 1
WHERE
	InvoiceItems.InvoiceId = @Id;
