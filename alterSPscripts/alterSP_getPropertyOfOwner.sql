﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_getPropertyOfOwner]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_getPropertyOfOwner]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_getPropertyOfOwner] @inNombre varchar(100), @inIdentificacion varchar(30)
AS
	BEGIN
		BEGIN TRY
			DECLARE @idPropietario INT
			SET @idPropietario = (	SELECT [id] 
									FROM [dbo].[Propietario] 
									WHERE [nombre] = @inNombre OR [identificacion] = @inIdentificacion AND [activo] = 1) 	
			SELECT [dbo].[Propiedad].[id], [dbo].[Propiedad].[numFinca], [dbo].[Propiedad].[valor], [dbo].[Propiedad].[direccion] 
			FROM [dbo].[Propiedad] JOIN [dbo].[PropiedadDelPropietario] ON ([dbo].[Propiedad].[id] = [dbo].[PropiedadDelPropietario].[id_Propiedad])
			WHERE [dbo].[PropiedadDelPropietario].[id_Propietario] = @idPropietario AND [dbo].[Propiedad].[activo] = 1 AND [dbo].[PropiedadDelPropietario].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 55200, 'Error: No se ha podido encontrar propiedad del propietario',1;
		END CATCH
	END
