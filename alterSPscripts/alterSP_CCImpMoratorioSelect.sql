﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCImpMoratorioSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCImpMoratorioSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCImpMoratorioSelect] 
    @inId int
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			SELECT [dbo].[CCImpMoratorio].[id]
			FROM   [dbo].[CCImpMoratorio] 
			INNER JOIN [dbo].[ConceptoDeCobro] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCImpMoratorio].id  
			WHERE  ([dbo].[CCImpMoratorio].[id] = @inId OR (@inId IS NULL OR @inId = -1)) AND [dbo].[ConceptoDeCobro].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 54678,'Error: No se ha podido mostrar el concepto de cobro de tipo moratorio',1;
		END CATCH
	END
