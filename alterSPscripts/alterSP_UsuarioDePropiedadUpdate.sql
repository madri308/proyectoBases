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
    @inUsuarioOriginal varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	BEGIN TRAN
		DECLARE @idPropiedad int, @idUsuario int,@idPropiedadOriginal int, @idUsuarioOriginal int
		BEGIN TRY
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo]=1)
			SET @idUsuario = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario AND [activo]=1)
			SET @idPropiedadOriginal = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFincaOriginal AND [activo]=1)
			SET @idUsuarioOriginal = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuarioOriginal AND [activo]=1)
		END TRY
		BEGIN CATCH;
			THROW 62534 , 'Error: No se han podido encontrar propiedades o usuarios con esos datos.',1;
		END CATCH
		BEGIN TRY
			UPDATE [dbo].[UsuarioDePropiedad]
				SET [id_Propiedad] = isNull(@idPropiedad,[id_Propiedad]),
					[id_Usuario]= isNull(@idUsuario,[id_Usuario]) 
				WHERE  [id_Propiedad] = @idPropiedadOriginal AND 
						[id_Usuario] = @idUsuarioOriginal AND
						 [activo] = 1
		END TRY
		BEGIN CATCH;
			THROW 82736,'Error: No se ha podido modificar la relacion entre la propiedad y el usuario',1;
		END CATCH
	

	COMMIT
