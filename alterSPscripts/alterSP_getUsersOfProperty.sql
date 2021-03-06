﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_getUsersOfProperty]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_getUsersOfProperty]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_getUsersOfProperty] @inNumFinca varchar(30)
AS
	BEGIN
		BEGIN TRY
			DECLARE @idFinca INT
			SET @idFinca = ( SELECT [id]
								FROM [dbo].[Propiedad]
								WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SELECT [dbo].[Usuario].[nombre],[dbo].[Usuario].[tipoDeUsuario],[dbo].[Usuario].[fechaDeIngreso], [dbo].[Usuario].[password]
			FROM [dbo].[Usuario] JOIN [dbo].[UsuarioDePropiedad] ON ([dbo].[Usuario].[id] = [dbo].[UsuarioDePropiedad].[id_Usuario])
			WHERE [dbo].[UsuarioDePropiedad].[id_Propiedad] = @idFinca AND [dbo].[Usuario].[activo] = 1 AND [dbo].[UsuarioDePropiedad].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 88100,'Error: No se ha podido encontrar ningun usuario de la propiedad.',1;
		END CATCH
	END
