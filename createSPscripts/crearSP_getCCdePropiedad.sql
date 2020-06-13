-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_getCCdePropiedad] @inNumfinca VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;
		BEGIN TRAN
			BEGIN TRY
				DECLARE @idFinca INT
				SET @idFinca = (	SELECT [id]
									FROM [dbo].[Propiedad] 
									WHERE [numFinca] = @inNumfinca)
			END TRY
			BEGIN CATCH
				THROW 66800 , 'Error: No se ha encontrado ninguna propiedad con el numero de finca',1
			END CATCH
			BEGIN TRY
				SELECT [dbo].[CCConsumo].[valorPorM3],[dbo].[ConceptoDeCobro].[esImpuesto],[dbo].[ConceptoDeCobro].[esRecurrente],[dbo].[ConceptoDeCobro].[esFijo],[dbo].[ConceptoDeCobro].[monto],[dbo].[ConceptoDeCobro].[nombre],
						[dbo].[ConceptoDeCobro].[tasaImpuestoMoratorio],[dbo].[ConceptoDeCobro].[id],[dbo].[ConceptoDeCobro].[diasParaVencer],
						[dbo].[ConceptoDeCobro].[diaDeCobro], [dbo].[CCFijo].[Monto],[dbo].[CCPorcentaje].[valorPorcentual]
				FROM   [dbo].[ConceptoDeCobro]
				LEFT OUTER JOIN [dbo].[CCConsumo] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCConsumo].[id]
				LEFT OUTER JOIN [dbo].[CCFijo] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCFijo].[id]
				LEFT OUTER JOIN [dbo].[CCImpMoratorio] ON [ConceptoDeCobro].[id] = [dbo].[CCImpMoratorio].[id]
				LEFT OUTER JOIN [dbo].[CCPorcentaje] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCPorcentaje].[id]
				WHERE [dbo].[ConceptoDeCobro].[activo] = 1 AND [dbo].[ConceptoDeCobro].[id] IN (SELECT [id_CC] FROM [dbo].[CCDePropiedad] WHERE [id_Propiedad] = @idFinca AND [activo] = 1)
			END TRY
			BEGIN CATCH
				THROW 66900,'Error: No se han podido mostrar los conceptos de cobro de la propiedad',1
			END CATCH
		COMMIT
END
GO
