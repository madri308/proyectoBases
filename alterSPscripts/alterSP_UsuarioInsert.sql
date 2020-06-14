USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioInsert] @inNombre VARCHAR(100),@inPassword VARCHAR(30),@inTipoDeUsuario VARCHAR(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[Usuario] ([nombre], [password], [tipoDeUsuario],[fechaDeIngreso])
			SELECT @inNombre, @inPassword, @inTipoDeUsuario,CONVERT(VARCHAR(10), getdate(), 126)
			WHERE (@inNombre != '-1' ) AND 
					(@inPassword != '-1') AND 
					(@inTipoDeUsuario != '-1' )
		END TRY
		BEGIN CATCH
			THROW 762839,'Error: No se ha podido insertar el usuario, por favor revise los datos',1;
		END CATCH
	COMMIT
