USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcesarPagos]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcesarPagos]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcesarPagos] 
@Pagos PagosTipo READONLY
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON

			SELECT *
			INTO #RecibosPendientes
			FROM [dbo].[Recibos]
			WHERE [dbo].[Recibos].[estado] = 0

			DECLARE @idRecibo INT
			SET @idRecibo = (SELECT id FROM #RecibosPendientes WHERE fecha = min(fecha))

			UPDATE [dbo].[Recibos] 
			SET [dbo].[Recibos].[estado] = 1
			WHERE [dbo].[Recibos].[id_Propiedad] 
				IN (SELECT [dbo].[Propiedad].[id] 
					FROM [Propiedad] 
					WHERE numFinca 
						IN (SELECT numFinca FROM @Pagos WHERE Recibos.id_CC 
																IN (SELECT id_CC FROM @Pagos)))
						AND id = @idRecibo


		END TRY
		BEGIN CATCH
			THROW 6000, 'Error: No se ha podido crear el pago.',1;
		END CATCH
	END
