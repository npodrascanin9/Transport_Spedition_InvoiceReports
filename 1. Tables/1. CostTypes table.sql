USE TransportSpeditionDb;

CREATE TABLE [CostTypes]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Type] NVARCHAR(100) NOT NULL,
	[TypeCode] VARCHAR(5) NOT NULL,
	[Description] NVARCHAR(500) NOT NULL,
	[IsActive] BIT NOT NULL
);

ALTER TABLE CostTypes
ADD CONSTRAINT UQ_CostTypes_TypeCode
UNIQUE ([TypeCode]);
