GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioSelect]    Script Date: 6/2/2020 5:09:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioSelect] 
    @inUsuario varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [nombre],[password],[tipoDeUsuario] 
			FROM   [dbo].[Usuario] 
			WHERE  ([nombre] = @inUsuario OR @inUsuario IS NULL) AND [activo] = 1 
		END TRY	
		BEGIN CATCH
			THROW 910293,'Error: No se han podido mostrar los usuarios.',1;
		END CATCH
	COMMIT
