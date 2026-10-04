USE TransportSpeditionDb;

CREATE TABLE [Subjects]
(
	[Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[SubjectName] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(500) NULL
);
