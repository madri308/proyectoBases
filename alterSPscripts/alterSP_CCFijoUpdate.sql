﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCFijoUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCFijoUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCFijoUpdate] 
    @inId int,
    @inMonto money
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			UPDATE [dbo].[CCFijo]
			SET    [Monto] = @inMonto
			WHERE  [id] = @inId AND @inId > -1 AND @inMonto > -1 AND EXISTS
					(SELECT [activo] FROM [dbo].[ConceptoDeCobro] WHERE [id] = @inId) 
		END TRY
		BEGIN CATCH
			THROW 59870 , 'Error: No se ha podido modificar el concepto de cobro de tipo fijo',1;
		END CATCH
	END
