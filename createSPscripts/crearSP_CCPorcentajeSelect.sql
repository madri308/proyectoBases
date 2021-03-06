GO
/****** Object:  StoredProcedure [dbo].[SP_CCPorcentajeSelect]    Script Date: 6/2/2020 4:50:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [id], [valorPorcentual] 
			FROM   [dbo].[CCPorcentaje] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 76890 , 'Error: No se ha podido mostrar el concepto de cobro de tipo porcentual',1;
		END CATCH
	COMMIT
