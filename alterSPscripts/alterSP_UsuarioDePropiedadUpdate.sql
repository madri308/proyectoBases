USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioDePropiedadUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioDePropiedadUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDePropiedadUpdate] 
    @inNumFinca varchar(30),
    @inUsuario varchar(100),
	@inNumFincaOriginal varchar(30),
    @inUsuarioOriginal varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idPropiedad int, @idUsuario int,@idPropiedadOriginal int, @idUsuarioOriginal int, @jsonAntes varchar(500),@jsonDespues varchar(500), @idModified int, @insertedAt DATE
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo]=1)
			SET @idUsuario = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario AND [activo]=1)
			SET @idPropiedadOriginal = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFincaOriginal AND [activo]=1)
			SET @idUsuarioOriginal = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuarioOriginal AND [activo]=1)
			--GUARDA EL ID y fecha
			SET @insertedAt = GETDATE()
			SET @idModified = (SELECT [id] FROM [dbo].[UsuarioDePropiedad] WHERE [id_Propiedad] = @idPropiedadOriginal AND [id_Usuario] = @idUsuarioOriginal)
			--GUARDA EL JSON DEL ROW DE LA RELACION ANTES
			SET @jsonAntes = (SELECT [id], [id_Propiedad], [id_Usuario]
			FROM [dbo].[UsuarioDePropiedad] WHERE [id] = @idModified
			FOR JSON PATH)
			BEGIN TRAN
				--ACTUALIZA LA RELACION
				UPDATE [dbo].[UsuarioDePropiedad]
					SET [id_Propiedad] = isNull(@idPropiedad,[id_Propiedad]),
						[id_Usuario]= isNull(@idUsuario,[id_Usuario]) 
					WHERE  [id_Propiedad] = @idPropiedadOriginal AND 
							[id_Usuario] = @idUsuarioOriginal AND
							 [activo] = 1
				--GUARDA EL JSON DEL ROW DE LA RELACION DESPUES
				SET @jsonDespues = (SELECT [id], [id_Propiedad], [id_Usuario]
				FROM [dbo].[UsuarioDePropiedad] WHERE [id] = @idModified
				FOR JSON PATH)
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 5,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
													@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario, @inInsertedAt = @insertedAt
			COMMIT
		END TRY
		BEGIN CATCH;
			ROLLBACK TRAN;
			THROW 82736,'Error: No se ha podido modificar la relacion entre la propiedad y el usuario',1;
		END CATCH
	END
