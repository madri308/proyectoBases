USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcPropiedadVSPropietario]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcPropiedadVSPropietario]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcPropiedadVSPropietario] @PropiedadDelPropietario PropiedadDelPropietarioTipo READONLY
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			declare @jsonDespues varchar(500), @idMenor int, @idMayor int, @idModified int, @insertedAt DATE
			BEGIN TRAN
				SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @PropiedadDelPropietario
				SET @insertedAt = (SELECT Fecha FROM @PropiedadDelPropietario WHERE id = @idMenor)
				WHILE @idMenor<=@idMayor
				BEGIN
					--INSERTA LA RELACION
					INSERT INTO [dbo].[PropiedadDelPropietario] ([id_Propietario], [id_Propiedad])
					SELECT idPropietario,idPropiedad
					FROM @PropiedadDelPropietario 
					WHERE id = @idMenor
					--GUARDA EL ID
					SET @idModified = @@IDENTITY --(SELECT [id] FROM [dbo].[PropiedadDelPropietario] WHERE [id_Propiedad] IN (SELECT idPropiedad FROM @PropiedadDelPropietario WHERE id = @idMenor) AND [id_Propietario] = @idPropietario)
					--GUARDA EL JSON DEL ROW DE LA RELACION DESPUES
					SET @jsonDespues = (SELECT [id], [id_Propiedad], [id_Propietario]
					FROM [dbo].[PropiedadDelPropietario] WHERE [id] = @idModified
					FOR JSON PATH)
					--INSERTA EL CAMBIO
					EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 4,@inEntityID = @idModified, @inJsonAntes = NULL,
														@inJsonDespues = @jsonDespues, @inInsertedBy = 'usuario1', 
														@inInsertedIn = 123, @inInsertedAt = @insertedAt
					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 982734,'Error: No se han podido procesar los propietarios.',1;
		END CATCH
	END
