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
CREATE PROC [dbo].[SP_PropiedadDelPropietarioInsert] @inNumFinca varchar(30), @inIdentificacion varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		DECLARE @idPropiedad int, @idPropietario int
		BEGIN TRY
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idPropietario = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion AND [activo] = 1)
		END TRY
		BEGIN CATCH
			THROW 86786,'Error: No se ha podido encontrar propiedad o propietario con los datos especificados.',1;
		END CATCH
		BEGIN TRY
			INSERT INTO [dbo].[PropiedadDelPropietario] ([id_Propietario], [id_Propiedad])
			SELECT @idPropietario,@idPropiedad
			WHERE NOT EXISTS(SELECT [id] FROM PropiedadDelPropietario WHERE [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario AND [activo] = 1)
		END TRY
		BEGIN CATCH
			THROW 73654,'Error: No se ha podido insertar una relacion entre el propietario y la propiedad',1;
		END CATCH
	COMMIT

