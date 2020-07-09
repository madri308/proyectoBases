USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioDePropiedadDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioDePropiedadDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDePropiedadDelete] 
    @inUsuario varchar(100), @inNumFinca varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @idUsuario int, @idPropiedad int, @insertedAt DATE, @jsonAntes varchar(500), @idModified int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idUsuario = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario AND [activo] = 1)
			--GUARDA EL ID y fecha
			SET @insertedAt = GETDATE()
			SET @idModified = (SELECT [id] FROM [dbo].[UsuarioDePropiedad] WHERE [id_Propiedad] = @idPropiedad AND [id_Usuario] = @idUsuario AND [activo]=1)
			--GUARDA EL JSON DEL ROW DE LA RELACION ANTES
			SET @jsonAntes = (SELECT [id], [id_Propiedad], [id_Usuario]
			FROM [dbo].[UsuarioDePropiedad] WHERE [id] = @idModified
			FOR JSON PATH)
			BEGIN TRAN
				--ELIMINA LA RELACION
				UPDATE [dbo].[UsuarioDePropiedad]
				SET    [activo] = 0
				WHERE  [id_Usuario] = @idUsuario AND [id_Propiedad] = @idPropiedad
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 5,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
													@inJsonDespues = NULL, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario, @inInsertedAt = @insertedAt
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 92836,'Error: No se ha podido eliminar la relacion entre el usuario y la propiedad.',1;
		END CATCH
	END
