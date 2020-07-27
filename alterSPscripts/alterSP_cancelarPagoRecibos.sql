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
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			--ANULA LOS RECIBOS MORATORIOS QUE ESTABAN EN LA TABLA
			UPDATE [dbo].[Recibos]
			SET estado = 2
			FROM [dbo].[Recibos] R
			INNER JOIN idRecibosPagarTable idRP ON R.id = idRP.idRecibo
			WHERE R.id_CC = 11
			--ELIMINA LA TABLA YA QUE NO LA NECESITO MAS
			delete [idRecibosPagarTable]
	END