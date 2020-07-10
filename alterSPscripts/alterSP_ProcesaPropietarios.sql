USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcesaPropietarios]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcesaPropietarios]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcesaPropietarios] @inPropietario PropietarioTipo READONLY
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			declare @jsonDespues varchar(500), @idMenor int, @idMayor int, @idModified int, @insertedAt DATE
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @inPropietario
			SET @insertedAt = (SELECT Fecha FROM @inPropietario WHERE id = @idMenor)
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[Propietario](nombre,valorDocId,identificacion,fechaDeIngreso)
					SELECT nombre,valorDocId,identificacion,Fecha
					FROM @inPropietario 
					WHERE id = @idMenor
					SET @idModified = (SELECT id FROM [dbo].[Propietario] WHERE identificacion = (SELECT identificacion FROM @inPropietario WHERE id = @idMenor))

					SET @jsonDespues = (SELECT [id],[nombre],[valorDocId],[identificacion],[fechaDeIngreso]
									FROM [dbo].[Propietario] WHERE [activo] = 1 AND [id] = @idModified
									FOR JSON PATH)
					
					EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 2,@inEntityID = @idModified, @inJsonAntes = NULL,
																	@inJsonDespues = @jsonDespues, @inInsertedBy = 'usuario1', 
																	@inInsertedIn = 123, @inInsertedAt = @insertedAt
					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 982734,'Error: No se han podido procesar los propietarios.',1;
		END CATCH
	END
