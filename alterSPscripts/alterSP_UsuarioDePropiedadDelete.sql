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
    @inUsuario varchar(100), @inNumFinca varchar(30)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @idUsuario int, @idPropiedad int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idUsuario = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario AND [activo] = 1)
			UPDATE [dbo].[UsuarioDePropiedad]
			SET    [activo] = 0
			WHERE  [id_Usuario] = @idUsuario AND [id_Propiedad] = @idPropiedad
		END TRY
		BEGIN CATCH
			THROW 92836,'Error: No se ha podido eliminar la relacion entre el usuario y la propiedad.',1;
		END CATCH
	END
