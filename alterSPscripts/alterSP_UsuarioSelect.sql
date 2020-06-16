USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioSelect] @inUsuario varchar(30)
AS   
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			SELECT [nombre],[password],[tipoDeUsuario],[fechaDeIngreso]
			FROM   [dbo].[Usuario] 
			WHERE  ([nombre] = @inUsuario OR @inUsuario = '-1' OR @inUsuario IS NULL) AND [activo] = 1 
		END TRY	
		BEGIN CATCH
			THROW 910293,'Error: No se han podido mostrar el usuario.',1;
		END CATCH
	END
