GO
/****** Object:  StoredProcedure [dbo].[SP_CCConsumoInsert]    Script Date: 6/2/2020 4:34:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCConsumoInsert] 
    @inId int,
    @inValorPorM3 money
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[CCConsumo] ([id], [valorPorM3])
			SELECT @inId, @inValorPorM3
        END TRY
		BEGIN CATCH
			THROW 100000,'Error: No se ha podido insertar el concepto de cobro de tipo consumo.',1;
		END CATCH
	COMMIT
