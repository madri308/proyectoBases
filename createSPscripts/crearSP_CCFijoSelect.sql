GO
/****** Object:  StoredProcedure [dbo].[SP_CCFijoSelect]    Script Date: 6/2/2020 4:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCFijoSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [id], [Monto] 
			FROM   [dbo].[CCFijo] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 57890 , 'Error: No se han podido mostrar concepto de cobro de tipo fijo.',1;
		END CATCH
	COMMIT
