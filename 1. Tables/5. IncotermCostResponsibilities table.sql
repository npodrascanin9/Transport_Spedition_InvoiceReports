USE TransportSpeditionDb;

-- composite key
CREATE TABLE [IncotermCostResponsibilities]
(
	[IncotermRuleId] INT NOT NULL,
	[SubjectId] INT NOT NULL,
	[CostTypeId] INT NOT NULL,
	[AmountPercentage] DECIMAL(5,2) NOT NULL,
	[IsActive] BIT NOT NULL
);

ALTER TABLE IncotermCostResponsibilities
ADD CONSTRAINT FK_IncotermCostResponsibilities_IncotermRules
FOREIGN KEY (IncotermRuleId) REFERENCES IncotermRules(Id);

ALTER TABLE IncotermCostResponsibilities
ADD CONSTRAINT FK_IncotermCostResponsibilities_Subjects
FOREIGN KEY (SubjectId) REFERENCES Subjects(Id);

ALTER TABLE IncotermCostResponsibilities
ADD CONSTRAINT FK_IncotermCostResponsibilities_CostTypes
FOREIGN KEY (CostTypeId) REFERENCES CostTypes(Id);

ALTER TABLE IncotermCostResponsibilities
ADD CONSTRAINT PK_IncotermCostResponsibilities
PRIMARY KEY 
(
	IncotermRuleId, 
	SubjectId, 
	CostTypeId
);
