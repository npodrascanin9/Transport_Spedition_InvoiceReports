USE TransportSpeditionDb;

GO

CREATE OR ALTER PROC spGetInvoiceReportById_v2
	@Id INT,
	@SubjectId INT = NULL
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
	,Invoices.IncotermRuleId
	,IncotermRules.Description
		AS IncotermRuleDescription
	,IncotermRules.IncotermCode
	,Invoices.Amount
	,Invoices.VatAmount
	,Invoices.TotalAmount
	,Invoices.CreatedAt
	,Invoices.UpdatedAt

FROM Invoices
INNER JOIN IncotermRules
	ON IncotermRules.Id = Invoices.IncotermRuleId
WHERE Invoices.Id = @Id;

-- 2nd data result-set: Invoice items
SELECT
	 InvoiceItems.Id
	,InvoiceItems.InvoiceId
	,InvoiceItems.CostTypeId
	,CostTypes.Type
		AS CostType
	,InvoiceSubjects.CompanyId
	,Companies.Name
		AS CompanyName
	,Companies.IdentificationNumber
	,Subjects.SubjectName
	,Responsibilities.AmountPercentage
		AS ResponsibilityPercentage -- how much the company owes
	,CalculatedAmounts.Amount
	,CalculatedAmounts.VatAmount
	,CalculatedAmounts.TotalAmount
	,FORMATMESSAGE(
		 'The company is responsible for %s%% of the total amount %s, which equals %s'
		,CAST(Responsibilities.AmountPercentage AS VARCHAR(20))
		,CAST(InvoiceItems.TotalAmount AS VARCHAR(30))
		,CAST(CalculatedAmounts.TotalAmount AS VARCHAR(30))
	) AS ObligationDescription

FROM InvoiceItems
INNER JOIN Invoices
	ON Invoices.Id = InvoiceItems.InvoiceId
INNER JOIN CostTypes
	ON CostTypes.Id = InvoiceItems.CostTypeId
	AND CostTypes.IsActive = 1
INNER JOIN IncotermCostResponsibilities Responsibilities
	ON Responsibilities.IncotermRuleId = Invoices.IncotermRuleId
	AND Responsibilities.CostTypeId = InvoiceItems.CostTypeId
	AND Responsibilities.IsActive = 1
	AND 
	(
        @SubjectId IS NULL
        OR Responsibilities.SubjectId = @SubjectId
    )
INNER JOIN InvoiceSubjects
	ON InvoiceSubjects.InvoiceId = Invoices.Id
	AND InvoiceSubjects.SubjectId = Responsibilities.SubjectId
INNER JOIN Subjects
	ON Subjects.Id = InvoiceSubjects.SubjectId
INNER JOIN Companies
	ON Companies.Id = InvoiceSubjects.CompanyId
CROSS APPLY dbo.CalculateAmounts
(
    Responsibilities.AmountPercentage,
    InvoiceItems.Amount,
    InvoiceItems.VatAmount
) AS CalculatedAmounts
WHERE
	InvoiceItems.InvoiceId = @Id
ORDER BY
	InvoiceItems.CostTypeId ASC;
