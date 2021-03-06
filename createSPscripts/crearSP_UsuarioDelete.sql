GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioDelete]    Script Date: 6/2/2020 5:07:09 PM ******/
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
