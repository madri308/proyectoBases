GO
/****** Object:  StoredProcedure [dbo].[SP_ConceptoDeCobroDelete]    Script Date: 6/2/2020 4:53:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ConceptoDeCobroDelete] 
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
			THROW 98789,'Error: No se ha podido eliminar el concepto de cobro',1;
		END CATCH
	COMMIT
