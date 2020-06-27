USE [Progra]
DECLARE @XMLData XML, @MinDate DATE, @MaxDate DATE
DECLARE @hdoc INT
SELECT @XMLData = C
FROM OPENROWSET (BULK 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\p1DATA\xmlData\TipoTransConsumo.xml', SINGLE_BLOB) AS ReturnData(C)
EXEC sp_xml_preparedocument @hdoc OUTPUT, @XMLData

INSERT INTO [dbo].[TipoMov] ([id],[nombre])
	SELECT [id],[nombre]
	FROM OPENXML (@hdoc,'TipoTransConsumo/TransConsumo', 1)
		WITH(
				[id]		INT				'@id',
				[nombre]	VARCHAR(100)	'@Nombre'
				)
EXEC sp_xml_removedocument @hdoc  
--DELETE [dbo].[TipoMov]