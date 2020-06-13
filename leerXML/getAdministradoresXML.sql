USE [Progra]
DECLARE @XMLData XML, @MinDate DATE, @MaxDate DATE
DECLARE @hdoc INT
SELECT @XMLData = C
FROM OPENROWSET (BULK 'C:\Users\emema\Documents\TEC\2020\SEM_I\BasesI\PrograI\Administradores.xml', SINGLE_BLOB) AS ReturnData(C)
EXEC sp_xml_preparedocument @hdoc OUTPUT, @XMLData

INSERT INTO [dbo].[Usuario] ([nombre],[password],[tipoDeUsuario],[fechaDeIngreso])
	SELECT [nombre],[password],[tipoDeUsuario],CONVERT(DATE,GETDATE(),126)
	FROM OPENXML (@hdoc,'Administrador/UsuarioAdmi', 1)
		WITH(
				[nombre] VARCHAR(100) '@user',
				[password] VARCHAR(30) '@password',
				[tipoDeUsuario] VARCHAR(30) '@tipo'
				)
EXEC sp_xml_removedocument @hdoc  
