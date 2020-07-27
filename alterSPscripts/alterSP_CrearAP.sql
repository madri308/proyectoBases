USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CrearAP]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CrearAP]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CrearAP] @inMeses INT, @inCuota MONEY
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE 
			@montoAP MONEY
			,@idPropiedad INT
			,@idComprobante INT
			,@TasaInteresAnual FLOAT
			,@idAP INT

			--SACA LA TASA ANUAL DE LA TABLA DE CONFIG
			SET @TasaInteresAnual = CONVERT(FLOAT,(SELECT valor FROM [dbo].[ValoresConfig] WHERE id = 1))
			
			--GUARDA EL ID DE LA PROPIEDAD
			SET @idPropiedad = (SELECT DISTINCT id_Propiedad FROM [dbo].[Recibos] R
								INNER JOIN idRecibosPagarAP idRP ON R.id = idRP.idRecibo)
			
			--GUARDA EL MONTO TOTAL
			SET @montoAP = (SELECT SUM(monto) 
							FROM [dbo].[Recibos] R 
							INNER JOIN idRecibosPagarAP idRP ON R.id = idRP.idRecibo)
			BEGIN TRAN
				--ACTUALIZA EL ESTADO A PAGADOS
				UPDATE [dbo].[Recibos]
				SET estado = 1
				FROM [dbo].[Recibos] R
				INNER JOIN idRecibosPagarAP idRP ON R.id = idRP.idRecibo

				--CREA UN COMPROBANTE DE PAGO
				INSERT INTO [dbo].[ComprobantePago](fecha,total,medioDePago)
				SELECT GETDATE(),@montoAP,'AP# '
				SET @idComprobante = IDENT_CURRENT('[dbo].[ComprobantePago]')

				--INSERTA LOS RECIBOS EN RECIBOS PAGADOS
				INSERT INTO [dbo].[ReciboPagado](id_Recibo,id_Comprobante)
				SELECT idRP.idRecibo,@idComprobante
				FROM idRecibosPagarAP idRP

				--ELIMINO LA TABLA YA QUE NO LA USO MAS
				DELETE idRecibosPagarAP

				--CREA UN AP
				INSERT INTO [dbo].[ArregloPago](IdPropiedad,IdComprobante,MontoOriginal,Saldo,TasaInteresAnual,PlazoOriginal,PlazoResta,Cuota,insertedAt,updatedAt)
				SELECT @idPropiedad,@idComprobante,@montoAP,@montoAP,@TasaInteresAnual,@inMeses,@inMeses,@inCuota,GETDATE(),GETDATE()
				SET @idAP = IDENT_CURRENT('[dbo].[ArregloPago]')

				--ACTUALIZA EL COMPROBANTE DE PAGO CON EL ID DEL AP
				UPDATE [dbo].[ComprobantePago]
				SET medioDePago += CAST(@idAP AS VARCHAR(30))
				FROM [dbo].[ComprobantePago]
				WHERE id = @idComprobante

				--GENERA UN MOVIMIENTO DE DEBITO, EL UNICO
				INSERT INTO [dbo].[MovimientosAP](idAP,idTipoMov,Monto,interesDelMes,plazoResta,nuevoSaldo,fecha,insertedAt)
				SELECT	@idAP
						,1
						,@montoAP
						,@montoAP*@TasaInteresAnual/12
						,@inMeses
						,@montoAP
						,GETDATE()
						,GETDATE()
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 55501,'Error al crear el arreglo de pago.',1;
		END CATCH
	END
