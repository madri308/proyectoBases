﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCFijoDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCFijoDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCFijoDelete] 
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
			THROW 68754,'Error: No se ha podido eliminar el concepto de cobro de tipo fijo',1;
		END CATCH
	END
