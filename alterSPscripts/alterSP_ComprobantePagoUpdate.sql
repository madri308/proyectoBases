﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ComprobantePagoUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ComprobantePagoUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoUpdate] 
    @inId int,
    @inFecha date,
    @inTotal money
AS   	
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			UPDATE [dbo].[ComprobantePago]
			SET    [fecha] = @inFecha, [total] = @inTotal
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 72456,'Error: No se ha podido modificar el comprobante de pago',1;
		END CATCH
	END
