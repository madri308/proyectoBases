﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_getOwnerOfProperty]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_getOwnerOfProperty]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_getOwnerOfProperty] @inNumFinca varchar(30)
AS
	BEGIN
		BEGIN TRY
			DECLARE @idFinca INT
			SET @idFinca = ( SELECT [id]
								FROM [dbo].[Propiedad]
								WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SELECT [dbo].[Propietario].[nombre], [dbo].[Propietario].[identificacion], [dbo].[Propietario].[valorDocId] ,[dbo].[Propietario].[fechaDeIngreso]
			FROM [dbo].[Propietario] JOIN [dbo].[PropiedadDelPropietario] ON ([dbo].[Propietario].[id] = [dbo].[PropiedadDelPropietario].[id_Propietario])
			WHERE [dbo].[PropiedadDelPropietario].[id_Propiedad] = @idFinca AND [dbo].[Propietario].[activo] = 1 AND [dbo].[PropiedadDelPropietario].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 55400, 'Error: No se ha encontrado propietario de esa propiedad',1;
		END CATCH
	END
