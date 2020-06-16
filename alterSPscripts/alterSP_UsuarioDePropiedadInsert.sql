USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioDePropiedadInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioDePropiedadInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDePropiedadInsert] @inUsuario varchar(100),@inNumFinca varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idUsuario int, @idPropiedad int,@jsonDespues varchar(500), @idModified int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idUsuario = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario AND [activo] = 1)
			--INSERTA LA RELACION
			INSERT INTO [dbo].[UsuarioDePropiedad] ([id_Propiedad], [id_Usuario])
			SELECT @idPropiedad, @idUsuario
			--GUARDA EL ID
			SET @idModified = (SELECT [id] FROM [dbo].[UsuarioDePropiedad] WHERE [id_Propiedad] = @idPropiedad AND [id_Usuario] = @idUsuario)
			--GUARDA EL JSON DEL ROW DE LA RELACION DESPUES
			SET @jsonDespues = (SELECT [id], [id_Propiedad], [id_Usuario]
			FROM [dbo].[UsuarioDePropiedad] WHERE [id_Propiedad] = @idPropiedad AND [id_Usuario] = @idUsuario
			FOR JSON PATH)
			--INSERTA EL CAMBIO
			EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = NULL,
												@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
												@inInsertedIn = @inIPusuario
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 83645,'Error: No se ha podido insertar la relacion entre el usuario y la propiedad.',1;
		END CATCH      
	END
