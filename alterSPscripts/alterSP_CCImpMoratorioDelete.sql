﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCImpMoratorioDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCImpMoratorioDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCImpMoratorioDelete] 
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
			THROW 98076, 'Error: No se ha podido eliminar el concepto de cobro de tipo moratorio.',1;
		END CATCH
	END
