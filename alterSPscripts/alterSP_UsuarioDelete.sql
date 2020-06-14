USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDelete] 
    @inUsuario varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY 
			UPDATE [dbo].[Usuario]
			SET    [activo] = 0
			WHERE  [nombre] = @inUsuario
		END TRY
		BEGIN CATCH
			THROW 92039, 'Error: no se ha podido eliminar el usuario.',1
		END CATCH;
	COMMIT
