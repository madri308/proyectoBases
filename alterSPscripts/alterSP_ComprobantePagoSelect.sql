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
	@inIdRecibo INT
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			SELECT CP.fecha, CP.total 
			FROM   [dbo].[ComprobantePago] CP
			INNER JOIN [dbo].[ReciboPagado] RP ON RP.id_Comprobante = CP.id
			INNER JOIN [dbo].[Recibos] R ON R.id = RP.id_Recibo
			WHERE R.id = @inIdRecibo
		END TRY
		BEGIN CATCH
			THROW 53901,'Error: No se ha podido mostrar comprobante de pago.',1;
		END CATCH
	END
