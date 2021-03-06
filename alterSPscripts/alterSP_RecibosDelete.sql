﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_RecibosDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_RecibosDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_RecibosDelete] 
    @id int
AS  
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			UPDATE [dbo].[Usuario]
			SET    [activo] = 0
			WHERE  [id] = @id
		END TRY
		BEGIN CATCH
			THROW 934638,'Error: No se ha podido eliminar el recibo.',1;
		END CATCH
	END
