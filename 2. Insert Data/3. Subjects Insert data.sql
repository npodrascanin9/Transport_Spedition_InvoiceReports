USE TransportSpeditionDb;

BEGIN TRY
BEGIN TRANSACTION

IF NOT EXISTS
(
	SELECT 1
	FROM Subjects
	WHERE SubjectName = 'Buyer'
)
BEGIN
	INSERT INTO Subjects
	VALUES
	(
		'Buyer',
		'The company responsible for purchasing the goods.'
	)
END

IF NOT EXISTS
(
	SELECT 1
	FROM Subjects
	WHERE SubjectName = 'Seller'
)
BEGIN
	INSERT INTO Subjects
	VALUES
	(
		'Seller',
		'The company responsible for selling or supplying the goods.'
	)
END

COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @Message AS NVARCHAR(1000);

    SET @Message =
        'Transaction Rollbacked! Error at line '
        + CONVERT(NVARCHAR, ERROR_LINE())
        + ISNULL(' on procedure ' + ERROR_PROCEDURE(), '')
        + ': '
        + ERROR_MESSAGE();

    RAISERROR(@Message, 11, 1);
END CATCH
