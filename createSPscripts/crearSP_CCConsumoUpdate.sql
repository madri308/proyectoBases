GO
/****** Object:  StoredProcedure [dbo].[SP_CCConsumoUpdate]    Script Date: 6/2/2020 4:36:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCConsumoUpdate] @inId int,@inValorPorM3 money
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[CCConsumo]
			SET    [valorPorM3] = @inValorPorM3
			WHERE  [id] = @inId AND @inValorPorM3 IS NOT NULL
		END TRY
		BEGIN CATCH
			THROW 50999,'Error: No se ha podido modificar el concepto de cobro tipo consumo.',1;
		END CATCH
	COMMIT
