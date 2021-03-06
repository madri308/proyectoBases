﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ConceptoDeCobroSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ConceptoDeCobroSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ConceptoDeCobroSelect] 
    @inId int
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			SELECT [id], [nombre], [diasParaVencer], [diaDeCobro], [tasaImpuestoMoratorio],[esImpuesto],
					[esRecurrente],[esFijo],[monto]
			FROM   [dbo].[ConceptoDeCobro] 
			WHERE  ([id] = @inId OR @inId IS NULL OR @inId = -1)  AND [activo] = 1
		END TRY
		BEGIN CATCH
			THROW 97456,'Error: No se ha podido mostrar el concepto de cobro',1;
		END CATCH
	END
