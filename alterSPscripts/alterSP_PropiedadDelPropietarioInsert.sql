USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadDelPropietarioInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadDelPropietarioInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioInsert] @inNumFinca varchar(30), @inIdentificacion varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idPropiedad int, @idPropietario int, @jsonDespues varchar(500), @idModified int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idPropietario = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion AND [activo] = 1)
			--GUARDA EL ID
			SET @idModified = (SELECT [id] FROM [dbo].[PropiedadDelPropietario] WHERE [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario)
			--INSERTA LA RELACION
			INSERT INTO [dbo].[PropiedadDelPropietario] ([id_Propietario], [id_Propiedad])
			SELECT @idPropietario,@idPropiedad
			WHERE NOT EXISTS(SELECT [id] FROM PropiedadDelPropietario WHERE [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario AND [activo] = 1)
			--GUARDA EL JSON DEL ROW DE LA RELACION DESPUES
			SET @jsonDespues = (SELECT [id], [id_Propiedad], [id_Propietario]
			FROM [dbo].[PropiedadDelPropietario] WHERE [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario
			FOR JSON PATH)
			--INSERTA EL CAMBIO
			EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = NULL,
												@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
												@inInsertedIn = @inIPusuario
		
		END TRY
		BEGIN CATCH
			THROW 73654,'Error: No se ha podido insertar una relacion entre el propietario y la propiedad',1;
		END CATCH
	END

