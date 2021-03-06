﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCConsumoSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCConsumoSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCConsumoSelect] 
    @inId int
AS  

	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			SELECT [dbo].[CCConsumo].[id], [dbo].[CCConsumo].[valorPorM3] 
			FROM   [dbo].[CCConsumo] 
			INNER JOIN [dbo].[ConceptoDeCobro] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCConsumo].[id]  
			WHERE  ([dbo].[CCConsumo].[id] = @inId OR (@inId IS NULL OR @inId = -1)) AND [dbo].[ConceptoDeCobro].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 55555,'Error: No se ha podido mostrar los conceptos de cobro tipo Consumo',1;
		END CATCH
	END
