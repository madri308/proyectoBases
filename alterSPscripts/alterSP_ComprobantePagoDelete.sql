﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ComprobantePagoDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ComprobantePagoDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoDelete] 
    @inId int
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			UPDATE [dbo].[Usuario]
			SET    [activo] = 0
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 53789 , 'Error: No se ha podido eliminar el comprobante de pago' , 1;
		END CATCH
	END
