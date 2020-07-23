USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_completarPagoRecibos]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_completarPagoRecibos]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_completarPagoRecibos]
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @montoComprobante MONEY
			BEGIN TRAN
				--ACTUALIZA EL ESTADO A PAGADOS
				UPDATE [dbo].[Recibos]
				SET estado = 1
				FROM [dbo].[Recibos] R
				INNER JOIN ##idRecibosPagar idRP ON R.id = idRP.idRecibo
				--GUARDA EL MONTO TOTAL
				SET @montoComprobante = (SELECT SUM(monto) 
											FROM [dbo].[Recibos] R 
											INNER JOIN ##idRecibosPagar idRP ON R.id = idRP.idRecibo)
				--CREA UN COMPROBANTE DE PAGO
				INSERT INTO [dbo].[ComprobantePago](fecha,total,medioDePago)
				SELECT GETDATE(),@montoComprobante,'Corriente'
				--INSERTA LOS RECIBOS EN RECIBOS PAGADOS
				INSERT INTO [dbo].[ReciboPagado](id_Recibo,id_Comprobante)
				SELECT idRP.idRecibo,IDENT_CURRENT('[dbo].[ComprobantePago]')
				FROM ##idRecibosPagar idRP
				--ELIMINA LA TABLA YA QUE NO LA NECESITO MAS
				DROP TABLE ##idRecibosPagar
			COMMIT
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 92039, 'Error: no se ha podido completar el pago de los recibos.',1
		END CATCH;
	END
