﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCConsumoUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCConsumoUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCConsumoUpdate] @inId int,@inValorPorM3 money
AS 
	
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			UPDATE [dbo].[CCConsumo]
			SET    [valorPorM3] = @inValorPorM3
			WHERE  [id] = @inId AND @inValorPorM3 > -1 AND EXISTS
					(SELECT [activo] FROM [dbo].[ConceptoDeCobro] WHERE [id] = @inId) 
		END TRY
		BEGIN CATCH
			THROW 50999,'Error: No se ha podido modificar el concepto de cobro tipo consumo.',1;
		END CATCH
	END
