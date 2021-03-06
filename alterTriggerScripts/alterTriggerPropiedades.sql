USE [Progra]
GO

IF OBJECT_ID('[dbo].[trigger_cambiosPropiedad]') IS NOT NULL
BEGIN 
    DROP TRIGGER [dbo].[trigger_cambiosPropiedad]  
END 
GO
CREATE TRIGGER [dbo].[trigger_cambiosPropiedad]
ON [dbo].[Propiedad]
AFTER  INSERT,UPDATE
AS				
	declare @jsonAntes varchar(500), @jsonDespues varchar(500), @idMenor int, @idMayor int, @insertedAt DATE
	SELECT @idMenor = min([id]), @idMayor=max([id]) FROM inserted
	SET @insertedAt = (SELECT fechaDeIngreso FROM inserted WHERE [id] = @idMenor)
	WHILE @idMenor<=@idMayor
		BEGIN
			IF @idMenor IN (SELECT id FROM inserted) OR @idMenor IN (SELECT id FROM deleted)
			BEGIN
				SET @jsonAntes = (SELECT [id], [valor], [direccion], [numFinca], [fechaDeIngreso],[M3acumuladosAgua],[M3AcumuladosUltimoRecibo]
								FROM deleted WHERE [id] = @idMenor AND activo = 1
								FOR JSON PATH)
				SET @jsonDespues = (SELECT [id], [valor], [direccion], [numFinca], [fechaDeIngreso],[M3acumuladosAgua],[M3AcumuladosUltimoRecibo]
								FROM inserted WHERE [id] = @idMenor AND activo = 1
								FOR JSON PATH)
				EXEC [dbo].[SP_BitacoraCambioInsert] 
				@inIdEntityType = 1,
				@inEntityID = @idMenor, 
				@inJsonAntes = @jsonAntes,
				@inJsonDespues = @jsonDespues, 
				@inInsertedBy = 'usuario1', 
				@inInsertedIn = '1.1787.0289',
				@inInsertedAt = @insertedAt
			END
			SET @idMenor = @idMenor+1 
		END


