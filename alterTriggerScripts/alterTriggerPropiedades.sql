USE [Progra]
GO

IF OBJECT_ID('[dbo].[cambiosPropiedad]') IS NOT NULL
BEGIN 
    DROP TRIGGER [dbo].[cambiosPropiedad]  
END 
GO
CREATE TRIGGER [dbo].[cambiosPropiedad]
ON [dbo].[Propiedad]
AFTER  INSERT,UPDATE
AS				
	declare @jsonAntes varchar(500), @jsonDespues varchar(500), @idMenor int, @idMayor int
	SELECT @idMenor = min([id]), @idMayor=max([id]) FROM inserted
	WHILE @idMenor<=@idMayor
	BEGIN
		SET @jsonAntes = (SELECT [id], [valor], [direccion], [numFinca], [fechaDeIngreso],[M3acumuladosAgua],[M3AcumuladosUltimoRecibo]
						FROM deleted WHERE [id] = @idMenor
						FOR JSON PATH)
		SET @jsonDespues = (SELECT [id], [valor], [direccion], [numFinca], [fechaDeIngreso],[M3acumuladosAgua],[M3AcumuladosUltimoRecibo]
						FROM inserted WHERE [id] = @idMenor
						FOR JSON PATH)
		EXEC [dbo].[SP_BitacoraCambioInsert] 
		@inIdEntityType = 1,
		@inEntityID = @idMenor, 
		@inJsonAntes = @jsonAntes,
		@inJsonDespues = @jsonDespues, 
		@inInsertedBy = 'usuario1', 
		@inInsertedIn = 123
		
		SET @idMenor = @idMenor+1 
	END


