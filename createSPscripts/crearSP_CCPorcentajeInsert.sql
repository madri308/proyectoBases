GO
/****** Object:  StoredProcedure [dbo].[SP_CCPorcentajeInsert]    Script Date: 6/2/2020 4:49:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeInsert] 
    @inId int,
    @inValorPorcentual int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[CCPorcentaje] ([id], [valorPorcentual])
			SELECT @inId, @inValorPorcentual
        END TRY
		BEGIN CATCH
			THROW 66002 ,'Error: No se ha podido crear concepto de cobro tipo porcentual.',1;
		END CATCH
	COMMIT
