USE TransportSpeditionDb;

CREATE TABLE [Companies]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	[Tin] VARCHAR(100) NULL,
	[IdentificationNumber] VARCHAR(100) NULL,
	[Country] NVARCHAR(100) NOT NULL,
	[IsActive] BIT NOT NULL,
	[IsOurCompany] BIT NOT NULL,
	[CreatedAt] DATETIME NOT NULL,
	[UpdatedAt] DATETIME NOT NULL
);

CREATE UNIQUE INDEX UX_Companies_IsOurCompany
ON Companies
(
	IsOurCompany
)
WHERE IsOurCompany = 1;

CREATE UNIQUE INDEX UX_Companies_IdentificationNumber
ON Companies(IdentificationNumber)
WHERE IdentificationNumber IS NOT NULL;

CREATE UNIQUE INDEX UX_Companies_Tin
ON Companies(Tin)
WHERE Tin IS NOT NULL;
