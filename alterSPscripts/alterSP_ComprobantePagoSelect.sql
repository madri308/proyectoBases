USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ComprobantePagoSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ComprobantePagoSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoSelect] 
     @inNumFinca varchar(100)
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			SELECT [id], [fecha], [total] 
			FROM   [dbo].[ComprobantePago] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 53901,'Error: No se ha podido mostrar comprobante de pago.',1;
		END CATCH
	END
