USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ReciboDeComprobanteSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ReciboDeComprobanteSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ReciboDeComprobanteSelect] 
	@inIdComprobantePago INT
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			SELECT R.id
				,R.id_CC
				,R.monto
				,R.estado
				,R.activo
				,R.id_Propiedad
				,R.fecha
				,R.fechaVence
				,RAP.descripcion
				,RAP.idMovAP
			FROM [dbo].[Recibos] R
			LEFT OUTER JOIN [dbo].[RecibosAP] RAP ON R.id = RAP.id
			INNER JOIN [dbo].[ReciboPagado] RP ON RP.id_Recibo = R.id
			WHERE RP.id_Comprobante = @inIdComprobantePago
		END TRY
		BEGIN CATCH
			THROW 532901,'Error: No se ha podido mostrar recibo de comprobante de pago.',1;
		END CATCH
	END
