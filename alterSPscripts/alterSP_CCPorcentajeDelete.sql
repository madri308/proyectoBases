﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCPorcentajeDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCPorcentajeDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeDelete] 
    @inId int
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			UPDATE [dbo].[ConceptoDeCobro]
			SET    [activo] = 0
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 50987 , 'Error: No se ha podido eliminar el concepto de cobro de tipo porcentual' ,1;
		END CATCH
	END
