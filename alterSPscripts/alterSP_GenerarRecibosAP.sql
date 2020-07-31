USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_GenerarRecibosAP]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_GenerarRecibosAP]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GenerarRecibosAP] @inFecha DATE
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @dia int
			,@interesDelMes MONEY
			,@amortizacion MONEY
			,@idMenor INT
			,@idMayor INT
			,@idRecibo INT
			,@TasaInteresAnual FLOAT
			,@plazoRestante INT
			,@nuevoSaldo MONEY
			,@idMov INT
			DECLARE @idAPs TABLE(id INT IDENTITY(1,1),idAP int)

			SET @TasaInteresAnual = CONVERT(FLOAT,(SELECT valor FROM [dbo].[ValoresConfig] WHERE id = 1))
			SET @dia  = DAY(@inFecha)

			--GUARDA LOS IDS DE LOS APS QUE SE GENERARON ESTE DIA
			INSERT INTO @idAPs(idAP)
			SELECT id 
			FROM [dbo].[ArregloPago]
			WHERE DAY(insertedAt) = @dia AND PlazoResta != 0

			--GUARDA LOS IDS MENOR Y MAYOR PARA ITERAR
			SELECT @idMenor = MIN(id), @idMayor = MAX(id) FROM @idAPs
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					SET @interesDelMes = ((SELECT AP.Saldo 
											FROM [dbo].[ArregloPago] AP
											INNER JOIN @idAPs idAPs ON AP.id = idAPs.idAP
<<<<<<< HEAD
											WHERE idAPs.id = @idMenor)*@TasaInteresAnual/12)/100
=======
											WHERE idAPs.id = @idMenor)*@TasaInteresAnual/12) / 100
>>>>>>> 4a9bfc302122f52a24a094b6a37360cfb31380f6
					SET @amortizacion = (SELECT AP.Cuota
											FROM [dbo].[ArregloPago] AP
											INNER JOIN @idAPs idAPs ON AP.id = idAPs.idAP
											WHERE idAPs.id = @idMenor)-@interesDelMes
					--SE ACTUALIZA EL AP
					UPDATE [dbo].[ArregloPago]
					SET Saldo = Saldo - @amortizacion,
					PlazoResta = PlazoResta-1
					FROM [dbo].[ArregloPago] AP 
					INNER JOIN @idAPs idAPs ON AP.id = idAPs.idAP
					WHERE idAPs.id = @idMenor

					SET @plazoRestante = (SELECT AP.PlazoResta 
											FROM [dbo].[ArregloPago] AP
											INNER JOIN @idAPs idAPs ON AP.id = idAPs.idAP
											WHERE idAPs.id = @idMenor)
					SET @nuevoSaldo = (SELECT AP.saldo
											FROM [dbo].[ArregloPago] AP
											INNER JOIN @idAPs idAPs ON AP.id = idAPs.idAP
											WHERE idAPs.id = @idMenor )
					--SE GENERA EL MOVIMIENTO
					INSERT INTO [dbo].[MovimientosAP](idAP,idTipoMov,Monto,interesDelMes,plazoResta,nuevoSaldo,fecha,insertedAt)
					SELECT AP.id,0,@amortizacion,@interesDelMes,@plazoRestante,@nuevoSaldo,@inFecha,@inFecha
					FROM [dbo].[ArregloPago] AP
					INNER JOIN @idAPs idAPs ON AP.id = idAPs.idAP
					WHERE idAPs.id = @idMenor
					SET @idMov = IDENT_CURRENT('[dbo].[MovimientosAP]')

					--SE GENERA EL RECIBO DEL AP
					INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
					SELECT CC.id,AP.Cuota,0,AP.IdPropiedad,@inFecha,DATEADD(D,CC.diasParaVencer,@inFecha)
					FROM @idAPs idAPs 
					INNER JOIN[dbo].[ConceptoDeCobro] CC ON CC.id = 12
					INNER JOIN [ArregloPago] AP ON AP.id = idAPs.idAP
					WHERE idAPs.id = @idMenor
					SET @idRecibo = IDENT_CURRENT('[dbo].[Recibos]')

					INSERT INTO [dbo].[RecibosAP](id,descripcion,idMovAP)
					SELECT @idRecibo
						,'Interes mensual:'+CAST(@interesDelMes AS VARCHAR(30))
						+', amortizacion:'+CAST(@amortizacion AS VARCHAR(30))
						+', plazo resta:'+CAST(@plazoRestante AS VARCHAR(30))
						,@idMov
					SET @idMenor += 1
				END
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 55501,'Error, no se han podido generar los recibos del AP',1;
		END CATCH
	END
