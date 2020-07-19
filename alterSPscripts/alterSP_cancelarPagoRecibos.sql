USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_cancelarPagoRecibos]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_cancelarPagoRecibos]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_cancelarPagoRecibos]
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			UPDATE [dbo].[Recibos]
			SET estado = 2
			FROM [dbo].[Recibos] R
			INNER JOIN ##idRecibosPagar AS idRP ON R.id = idRP.idRecibo
			WHERE R.id_CC = 11
		END TRY
		BEGIN CATCH
			THROW 92039, 'Error: no se han podido cancelar los pagos de los recibos.',1
		END CATCH;
	END