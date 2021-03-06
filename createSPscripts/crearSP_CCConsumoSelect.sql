GO
/****** Object:  StoredProcedure [dbo].[SP_CCConsumoSelect]    Script Date: 6/2/2020 4:35:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCConsumoSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [dbo].[CCConsumo].[valorPorM3],[dbo].[ConceptoDeCobro].[esImpuesto],[dbo].[ConceptoDeCobro].[esRecurrente],[dbo].[ConceptoDeCobro].[esFijo],[dbo].[ConceptoDeCobro].[monto],[dbo].[ConceptoDeCobro].[nombre],
					[dbo].[ConceptoDeCobro].[tasaImpuestoMoratorio],[dbo].[ConceptoDeCobro].[id],[dbo].[ConceptoDeCobro].[diasParaVencer],
					[ConceptoDeCobro].[diaDeCobro] 
			FROM   [dbo].[CCConsumo]
			INNER JOIN [dbo].[ConceptoDeCobro] ON [dbo].[CCConsumo].[id] = [dbo].[ConceptoDeCobro].[id]
			WHERE ([dbo].[CCConsumo].[id] = @inId OR @inId IS NULL) AND [dbo].[ConceptoDeCobro].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 55555,'Error: No se ha podido mostrar los conceptos de cobro tipo Consumo',1;
		END CATCH
	COMMIT
