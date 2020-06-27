USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcPropiedadVSUsuario]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcPropiedadVSUsuario]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcPropiedadVSUsuario] @PropiedadDelUsuario PropiedadDelUsuarioTipo READONLY
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			declare @jsonDespues varchar(500), @idMenor int, @idMayor int, @idModified int
			BEGIN TRAN
				SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @PropiedadDelUsuario
				WHILE @idMenor<=@idMayor
				BEGIN
					--INSERTA LA RELACION
					INSERT INTO [dbo].[UsuarioDePropiedad] ([id_Usuario], [id_Propiedad])
					SELECT idUsuario,idPropiedad
					FROM @PropiedadDelUsuario
					WHERE id = @idMenor
					--GUARDA EL ID
					SET @idModified = @@IDENTITY --(SELECT [id] FROM [dbo].[PropiedadDelPropietario] WHERE [id_Propiedad] IN (SELECT idPropiedad FROM @PropiedadDelPropietario WHERE id = @idMenor) AND [id_Propietario] = @idPropietario)
					--GUARDA EL JSON DEL ROW DE LA RELACION DESPUES
					SET @jsonDespues = (SELECT [id], [id_Propiedad], [id_Usuario]
					FROM [dbo].[UsuarioDePropiedad] WHERE [id] = @idModified
					FOR JSON PATH)
					--INSERTA EL CAMBIO
					EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 5,@inEntityID = @idModified, @inJsonAntes = NULL,
														@inJsonDespues = @jsonDespues, @inInsertedBy = 'usuario1', 
														@inInsertedIn = 123
					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 982734,'Error: No se han podido procesar los propietarios.',1;
		END CATCH
	END
