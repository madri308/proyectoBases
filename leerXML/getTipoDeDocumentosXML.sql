USE [Progra]
DECLARE @XMLData XML, @MinDate DATE, @MaxDate DATE
DECLARE @hdoc INT
SELECT @XMLData = C
FROM OPENROWSET (BULK 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\p1DATA\xmlData\TipoDocumentoIdentidad.xml', SINGLE_BLOB) AS ReturnData(C)
EXEC sp_xml_preparedocument @hdoc OUTPUT, @XMLData

INSERT INTO [dbo].[TipoDeID] ([id], [nombre])
	SELECT [idDoc],[name]
	FROM OPENXML (@hdoc,'TipoDocIdentidad/TipoDocId', 1)
				WITH([idDoc] VARCHAR(100) '@codigoDoc',
					[name] VARCHAR(100) '@descripcion') 
EXEC sp_xml_removedocument @hdoc  
