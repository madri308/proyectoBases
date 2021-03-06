﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCFijoSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCFijoSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCFijoSelect] 
    @inId int
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			SELECT [dbo].[CCFijo].[id], [dbo].[CCFijo].[Monto] 
			FROM   [dbo].[CCFijo] 
			INNER JOIN [dbo].[ConceptoDeCobro] ON [dbo].[ConceptoDeCobro].[id] = [dbo].[CCFijo].id  
			WHERE  ([dbo].[CCFijo].[id] = @inId OR (@inId IS NULL OR @inId = -1)) AND [dbo].[ConceptoDeCobro].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 57890 , 'Error: No se han podido mostrar concepto de cobro de tipo fijo.',1;
		END CATCH
	END
