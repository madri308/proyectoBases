USE [Progra]
GO
IF OBJECT_ID('[dbo].[CCdePropiedadView]') IS NOT NULL
BEGIN 
    DROP VIEW [dbo].[CCdePropiedadView]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [CCdePropiedadView] AS
SELECT [dbo].[CCConsumo].[valorPorM3]
		,[dbo].[ConceptoDeCobro].[esImpuesto]
		,[dbo].[ConceptoDeCobro].[esRecurrente]
		,[dbo].[ConceptoDeCobro].[esFijo]
		,[dbo].[CCFijo].[Monto]
		,[dbo].[ConceptoDeCobro].[nombre]
		,[dbo].[ConceptoDeCobro].[tasaImpuestoMoratorio]
		,[dbo].[ConceptoDeCobro].[id]
		,[dbo].[ConceptoDeCobro].[diasParaVencer]
		,[dbo].[ConceptoDeCobro].[diaDeCobro]
		,[dbo].[CCPorcentaje].[valorPorcentual]
		,[dbo].[CCDePropiedad].[id_Propiedad]
FROM   [dbo].[ConceptoDeCobro]
LEFT OUTER JOIN [dbo].[CCConsumo] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCConsumo].[id]
LEFT OUTER JOIN [dbo].[CCFijo] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCFijo].[id]
LEFT OUTER JOIN [dbo].[CCImpMoratorio] ON [ConceptoDeCobro].[id] = [dbo].[CCImpMoratorio].[id]
LEFT OUTER JOIN [dbo].[CCPorcentaje] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCPorcentaje].[id]
INNER JOIN [dbo].[CCDePropiedad] ON [dbo].[CCDePropiedad].[id_CC] = [dbo].[ConceptoDeCobro].[id]
WHERE [dbo].[ConceptoDeCobro].[activo] = 1 AND [dbo].[CCDePropiedad].[activo] = 1;