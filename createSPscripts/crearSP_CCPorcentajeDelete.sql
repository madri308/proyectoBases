GO
/****** Object:  StoredProcedure [dbo].[SP_CCPorcentajeDelete]    Script Date: 6/2/2020 4:49:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeDelete] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Usuario]
			SET    [activo] = 0
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 50987 , 'Error: No se ha podido eliminar el concepto de cobro de tipo porcentual' ,1;
		END CATCH
	COMMIT
