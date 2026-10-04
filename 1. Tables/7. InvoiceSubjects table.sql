USE TransportSpeditionDb;

-- composite key
CREATE TABLE InvoiceSubjects
(
	InvoiceId INT NOT NULL,
	CompanyId INT NOT NULL,
	SubjectId INT NOT NULL -- Roles: Buyer, Seller
);

ALTER TABLE InvoiceSubjects
ADD CONSTRAINT FK_InvoiceSubjects_Invoices
FOREIGN KEY (InvoiceId) REFERENCES Invoices(Id);

ALTER TABLE InvoiceSubjects
ADD CONSTRAINT FK_InvoiceSubjects_Companies
FOREIGN KEY (CompanyId) REFERENCES Companies(Id);

ALTER TABLE InvoiceSubjects
ADD CONSTRAINT FK_InvoiceSubjects_Subjects
FOREIGN KEY (SubjectId) REFERENCES Subjects(Id);

ALTER TABLE InvoiceSubjects
ADD CONSTRAINT PK_InvoiceSubjects
PRIMARY KEY (InvoiceId, CompanyId, SubjectId)
