﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadDelPropietarioDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadDelPropietarioDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioDelete] @inNumFinca varchar(30), @inIdentificacion varchar(30)
AS  
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idPropiedad int, @idPropietario int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idPropietario = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion AND [activo] = 1)
			UPDATE [dbo].[PropiedadDelPropietario]
			SET    [activo] = 0
			WHERE  [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario
		END TRY
		BEGIN CATCH
			THROW 86784,'Error: No se ha podido eliminar la relacion entre la propiedad y el propietario.',1;
		END CATCH
	END
