GO
/****** Object:  StoredProcedure [dbo].[SP_CCPorcentajeUpdate]    Script Date: 6/2/2020 4:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeUpdate] 
    @inId int,
    @inValorPorcentual int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[CCPorcentaje]
			SET    [valorPorcentual] = @inValorPorcentual
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 70986 ,'Error: No se ha podido modificar el concepto de cobro tipo porcentual',1;
		END CATCH
	COMMIT
