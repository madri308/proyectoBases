GO
/****** Object:  StoredProcedure [dbo].[SP_CCFijoUpdate]    Script Date: 6/2/2020 4:47:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCFijoUpdate] 
    @inId int,
    @inMonto money
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[CCFijo]
			SET    [Monto] = @inMonto
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 59870 , 'Error: No se ha podido modificar el concepto de cobro de tipo fijo',1;
		END CATCH
	COMMIT
