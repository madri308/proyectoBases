USE [Progra]
DECLARE @XMLData XML, @MinDate DATE, @MaxDate DATE
DECLARE @hdoc INT
SELECT @XMLData = C
FROM OPENROWSET (BULK 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\p1DATA\xmlData\Usuarios.xml', SINGLE_BLOB) AS ReturnData(C)
EXEC sp_xml_preparedocument @hdoc OUTPUT, @XMLData

INSERT INTO [dbo].[Usuario] ([nombre],[password],[tipoDeUsuario],[fechaDeIngreso])
	SELECT [nombre],[password],[tipoDeUsuario],CONVERT(DATE,GETDATE(),126)
	FROM OPENXML (@hdoc,'Usuarios/Usuario', 1)
		WITH(
				[nombre] VARCHAR(100) '@user',
				[password] VARCHAR(30) '@password',
				[tipoDeUsuario] VARCHAR(30) '@tipo'
				)
EXEC sp_xml_removedocument @hdoc  
