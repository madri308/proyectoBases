USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_checkUserAndPasswordSP]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_checkUserAndPasswordSP]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_checkUserAndPasswordSP] @inPassword varchar(30), @inNombre varchar(30) 
AS
	BEGIN 
		BEGIN TRY
			DECLARE @tipoDeUsuario VARCHAR(30)
			SET @tipoDeUsuario =(	SELECT [tipoDeUsuario]
									FROM [dbo].[Usuario] 
									WHERE [nombre] = @inNombre AND [password] = @inPassword AND [activo] = 1)
		END TRY	
		BEGIN CATCH
			THROW 55500, 'Error: No se han encontrado usuarios con ese nombre o contrasenna',1 ;
		END CATCH
		BEGIN TRY
			IF @tipoDeUsuario = 'administrador'
				RETURN 1 --USUARIO ADMIN
			ELSE IF @tipoDeUsuario = 'normal'
				RETURN 0 --USUARIO NO ADMIN
			ELSE
				RETURN -1 --NO EXISTE
		END TRY	
		BEGIN CATCH
			THROW 55600,'Error: No se ha podido encontrar el tipo de usuario.',1;
		END CATCH
	END
