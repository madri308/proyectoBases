GO
/****** Object:  StoredProcedure [dbo].[SP_CCImpMoratorioSelect]    Script Date: 6/2/2020 4:48:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCImpMoratorioSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [id] 
			FROM   [dbo].[CCImpMoratorio] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 54678,'Error: No se ha podido mostrar el concepto de cobro de tipo moratorio',1;
		END CATCH
	COMMIT
