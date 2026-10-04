USE TransportSpeditionDb;

CREATE TABLE InvoiceItems
(
	Id INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	InvoiceId INT NOT NULL,
	CostTypeId INT NOT NULL,
	Amount DECIMAL(18, 2) NOT NULL,
	VatAmount DECIMAL(18, 2) NOT NULL,
	TotalAmount AS 
	(
		Amount + VatAmount
	)
);

ALTER TABLE InvoiceItems
ADD CONSTRAINT FK_InvoiceItems_Invoices
FOREIGN KEY (InvoiceId) REFERENCES Invoices(Id);

ALTER TABLE InvoiceItems
ADD CONSTRAINT FK_InvoiceItems_CostTypes
FOREIGN KEY (CostTypeId) REFERENCES CostTypes(Id);
