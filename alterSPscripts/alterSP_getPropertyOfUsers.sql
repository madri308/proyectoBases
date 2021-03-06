﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_getPropertyOfUsers]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_getPropertyOfUsers]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_getPropertyOfUsers] @inUsuario varchar(30)
AS
	BEGIN
		BEGIN TRY
			DECLARE @idUsuario INT
			SET @idUsuario = (	SELECT [id] 
									FROM [dbo].[Usuario] 
									WHERE [nombre] = @inUsuario AND [activo] = 1) 
			SELECT [dbo].[Propiedad].[numFinca], [dbo].[Propiedad].[valor], [dbo].[Propiedad].[direccion]
			FROM [dbo].[Propiedad] JOIN [dbo].[UsuarioDePropiedad] ON ([dbo].[Propiedad].[id] = [dbo].[UsuarioDePropiedad].[id_Propiedad])
			WHERE [dbo].[UsuarioDePropiedad].[id_Usuario] = @idUsuario AND [dbo].[Propiedad].[activo] = 1 AND [dbo].[UsuarioDePropiedad].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 77100,'Error: No se ha podido encontrar ninguna propiedad de el usuario.',1;
		END CATCH
	END
