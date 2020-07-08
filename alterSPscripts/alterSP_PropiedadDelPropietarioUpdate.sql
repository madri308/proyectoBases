USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadDelPropietarioUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadDelPropietarioUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioUpdate] 
    @inIdentificacionOriginal varchar(30),
    @inNumFincaOriginal varchar(30),
	@inIdentificacion varchar(30),
    @inNumFinca varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @idPropiedad int , @idPropietario int,@idPropiedadOriginal int , @idPropietarioOriginal int, @jsonAntes varchar(500),@jsonDespues varchar(500), @idModified int, @insertedAt DATE
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo]=1)
			SET @idPropietario = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion AND [activo]=1)
			SET @idPropiedadOriginal = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFincaOriginal AND [activo]=1)
			SET @idPropietarioOriginal = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacionOriginal AND [activo]=1)
			--GUARDA EL ID
			SET @idModified = (SELECT [id] FROM [dbo].[PropiedadDelPropietario] WHERE [id_Propiedad] = @idPropiedadOriginal AND [id_Propietario] = @idPropietarioOriginal)
			SET @insertedAt = GETDATE()
			--GUARDA EL JSON DEL ROW DE LA RELACION ANTES
			SET @jsonAntes = (SELECT [id], [id_Propiedad], [id_Propietario]
			FROM [dbo].[PropiedadDelPropietario] WHERE [id] = @idModified
			FOR JSON PATH)
			--ACTUALIZA LA RELACION
			UPDATE [dbo].[PropiedadDelPropietario]
				SET [id_Propietario] = isNull(@idPropietario,[id_Propietario]),
					[id_Propiedad]	=  isNull(@idPropiedad,[id_Propiedad])
				WHERE [id_Propiedad] = @idPropiedadOriginal AND [id_Propietario] = @idPropietarioOriginal AND
						[activo] = 1
			--GUARDA EL JSON DEL ROW DE LA RELACION DESPUES
			SET @jsonDespues = (SELECT [id], [id_Propiedad], [id_Propietario]
			FROM [dbo].[PropiedadDelPropietario] WHERE [id] = @idModified
			FOR JSON PATH)
			--INSERTA EL CAMBIO
			EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
												@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
												@inInsertedIn = @inIPusuario, @inInsertedAt  = @insertedAt
		END TRY
		BEGIN CATCH
			THROW 73256,'Error: No se ha podido modificar la relacion entre la propiedad y el propietario.',1;
		END CATCH
	END
