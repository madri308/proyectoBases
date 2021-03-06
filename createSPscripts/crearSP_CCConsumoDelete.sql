GO
/****** Object:  StoredProcedure [dbo].[SP_CCConsumoDelete]    Script Date: 6/2/2020 4:34:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCConsumoDelete] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[ConceptoDeCobro]
			SET    [activo] = 0
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 99000,'Error: No se ha podido eliminar el concepto de cobro tipo consumo.',1;
		END CATCH
	COMMIT
