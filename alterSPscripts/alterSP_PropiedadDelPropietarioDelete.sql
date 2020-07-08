USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadDelPropietarioDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadDelPropietarioDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioDelete] @inNumFinca varchar(30), @inIdentificacion varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS  
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idPropiedad int, @idPropietario int, @jsonAntes varchar(500), @idModified int, @insertedAt DATE
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idPropietario = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion AND [activo] = 1)
			--GUARDA EL ID Y FECHA
			SET @insertedAt = GETDATE()
			SET @idModified = (SELECT [id] FROM [dbo].[PropiedadDelPropietario] WHERE [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario)
			--GUARDA EL JSON DEL ROW DE LA RELACION ANTES
			SET @jsonAntes = (SELECT [id], [id_Propiedad], [id_Propietario]
			FROM [dbo].[PropiedadDelPropietario] WHERE [id] = @idModified
			FOR JSON PATH)
			--BORRA LA PROPIEDAD
			UPDATE [dbo].[PropiedadDelPropietario]
			SET    [activo] = 0
			WHERE  [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario
			--INSERTA EL CAMBIO
			EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
												@inJsonDespues = NULL, @inInsertedBy = @inUsuarioACargo, 
												@inInsertedIn = @inIPusuario, @inInsertedAt = @insertedAt

		END TRY
		BEGIN CATCH
			THROW 86784,'Error: No se ha podido eliminar la relacion entre la propiedad y el propietario.',1;
		END CATCH
	END
