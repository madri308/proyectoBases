-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_checkUserAndPasswordSP] @inPassword varchar(30), @inNombre varchar(30) 
AS
	BEGIN TRAN
		BEGIN TRY
			DECLARE @tipoDeUsuario VARCHAR(30)
			SET @tipoDeUsuario =(	SELECT [tipoDeUsuario]
									FROM [dbo].[Usuario] 
									WHERE [nombre] = @inNombre AND [password] = @inPassword)
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
	COMMIT
GO
