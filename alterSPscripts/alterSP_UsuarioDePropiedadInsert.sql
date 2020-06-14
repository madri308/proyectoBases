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
CREATE PROC [dbo].[SP_UsuarioDePropiedadInsert] @inUsuario varchar(100),@inNumFinca varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	BEGIN TRAN
		DECLARE @idUsuario int, @idPropiedad int
		BEGIN TRY
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idUsuario = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario AND [activo] = 1)
		END TRY
		BEGIN CATCH
			THROW 83925,'Error: No se ha encontrado propiedad o usuario, por favor verifique los datos.',1;
		END CATCH
         BEGIN TRY
			INSERT INTO [dbo].[UsuarioDePropiedad] ([id_Propiedad], [id_Usuario])
			SELECT @idPropiedad, @idUsuario
		END TRY
		BEGIN CATCH
			THROW 83645,'Error: No se ha podido insertar la relacion entre el usuario y la propiedad.',1;
		END CATCH      
	COMMIT
