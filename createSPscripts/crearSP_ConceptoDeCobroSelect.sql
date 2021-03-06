GO
/****** Object:  StoredProcedure [dbo].[SP_ConceptoDeCobroSelect]    Script Date: 6/2/2020 4:54:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ConceptoDeCobroSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [id], [nombre], [diasParaVencer], [diaDeCobro], [tasaImpuestoMoratorio] 
			FROM   [dbo].[ConceptoDeCobro] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 97456,'Error: No se ha podido mostrar el concepto de cobro',1;
		END CATCH
	COMMIT
