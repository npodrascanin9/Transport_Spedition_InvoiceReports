USE TransportSpeditionDb;

INSERT INTO CostTypes
(
    [Type],
    [TypeCode],
    [Description],
    [IsActive]
)
SELECT
    SeedData.[Type],
    SeedData.[TypeCode],
    SeedData.[Description],
    SeedData.[IsActive]
FROM
(
    VALUES
    (
        N'Sale of Goods',
        'SALE',
        N'Value of the goods sold as part of the commercial transaction.',
        CAST(1 AS BIT)
    ),
    (
        N'Transport',
        'TRANS',
        N'Cost of transporting goods from the origin to the destination.',
        CAST(1 AS BIT)
    ),
    (
        N'Customs Clearance',
        'CUST',
        N'Costs related to customs processing and clearance of goods.',
        CAST(1 AS BIT)
    ),
    (
        N'Insurance',
        'INS',
        N'Insurance cost related to the transportation of goods.',
        CAST(1 AS BIT)
    )
) AS SeedData
(
    [Type],
    [TypeCode],
    [Description],
    [IsActive]
)
WHERE NOT EXISTS
(
    SELECT 1
    FROM CostTypes
    WHERE CostTypes.TypeCode = SeedData.TypeCode
);
