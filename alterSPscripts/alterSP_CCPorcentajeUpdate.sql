﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCPorcentajeUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCPorcentajeUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeUpdate] 
    @inId int,
    @inValorPorcentual int
AS   
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			UPDATE [dbo].[CCPorcentaje]
			SET    [valorPorcentual] = @inValorPorcentual
			WHERE  [id] = @inId AND @inValorPorcentual != -1 AND EXISTS
					(SELECT [activo] FROM [dbo].[ConceptoDeCobro] WHERE [id] = @inId) 
		END TRY
		BEGIN CATCH
			THROW 70986 ,'Error: No se ha podido modificar el concepto de cobro tipo porcentual',1;
		END CATCH
	END
