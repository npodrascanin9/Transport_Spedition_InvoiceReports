USE TransportSpeditionDb;

-- Although there are 13 incoterms
-- To make this portfolio project simple, we are going to use only 3
-- EXW, FOB, and CIF

CREATE TABLE [IncotermRules]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1),
	[RuleTitle] NVARCHAR(50) NOT NULL,
	[IncotermCode] VARCHAR(3),
	[Description] NVARCHAR(500),
	[IsActive] BIT NOT NULL
);

