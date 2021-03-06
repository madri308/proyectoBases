﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCPorcentajeSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCPorcentajeSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeSelect] 
    @inId int
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  

			SELECT [dbo].[CCPorcentaje].[id], [dbo].[CCPorcentaje].[valorPorcentual] 
			FROM   [dbo].[CCPorcentaje] 
			INNER JOIN [dbo].[ConceptoDeCobro] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCPorcentaje].[id]  
			WHERE  ([dbo].[CCPorcentaje].[id] = @inId OR (@inId IS NULL OR @inId = -1)) AND [dbo].[ConceptoDeCobro].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 76890 , 'Error: No se ha podido mostrar el concepto de cobro de tipo porcentual',1;
		END CATCH
	END
