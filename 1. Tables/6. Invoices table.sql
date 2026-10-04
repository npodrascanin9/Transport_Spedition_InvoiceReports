USE TransportSpeditionDb;

/*
==================
Business change:

- During the analysis, the client requested support for Incoterm rules,
  such as EXW, CIF, FOB.
- The selected Incoterm rule determines the cost responsibility
  for each invoice item.

- The analysis showed that one invoice may involve multiple companies,
  each with a different business role, such as Buyer or Seller.
- Therefore, CompanyId was removed from the Invoices table.
- Invoice-related companies and their business roles are now stored
  in the InvoiceSubjects table.
==================
*/
CREATE TABLE Invoices
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	InvoiceDate DATE NOT NULL,
	DueDate DATE NOT NULL,
	IncotermRuleId INT NOT NULL,
	-- CompanyId INT NOT NULL => this is not needed anymore
	Amount DECIMAL(18,2) NOT NULL,
	VatAmount DECIMAL(18,2) NOT NULL,
	TotalAmount AS 
	(
		Amount + VatAmount
	),
	CreatedAt DATETIME NOT NULL,
	UpdatedAt DATETIME NOT NULL
);

ALTER TABLE Invoices
ADD CONSTRAINT FK_Invoices_IncotermRuleId
FOREIGN KEY (IncotermRuleId) REFERENCES IncotermRules(Id);
