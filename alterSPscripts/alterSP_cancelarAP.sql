USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_cancelarAP]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_cancelarAP]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_cancelarAP]
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			--ANULA LOS RECIBOS MORATORIOS QUE ESTABAN EN LA TABLA
			UPDATE [dbo].[Recibos]
			SET estado = 2
			FROM [dbo].[Recibos] R
			INNER JOIN idRecibosPagarAP idRP ON R.id = idRP.idRecibo
			WHERE R.id_CC = 11 AND R.estado = 3
			--ELIMINA LA TABLA YA QUE NO LA NECESITO MAS
			DELETE idRecibosPagarAP
		END TRY
		BEGIN CATCH
			THROW 92039, 'Error: no se han podido cancelar los pagos de los recibos.',1
		END CATCH;
	END