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
CREATE PROC [dbo].[SP_ProcesarPagos] @Pagos PagosTipo READONLY
AS   
	BEGIN
		--BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @idMenor INT, @idMayor INT, @idRecibo INT, @fechaVence DATE, @fechaOperacion DATE, @montoMoratorio MONEY,
					@idComprobante INT, @tasaMoratoria FLOAT, @montoRecibo MONEY
			SET @montoMoratorio = 0
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @Pagos
			SET @fechaOperacion = (SELECT fechaOperacion FROM @Pagos WHERE id = @idMenor)
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					--PAGA EL RECIBO MAS VIEJO PENDIENTE CORRESPONDIENTE AL CONCEPTO DE COBRO.
					SET @idRecibo = (SELECT TOP 1 R.id 
										FROM [dbo].[Recibos] R
										INNER JOIN @Pagos P ON P.idTipoRecibo = R.id_CC
										INNER JOIN [dbo].[Propiedad] PR ON PR.numFinca = P.numFinca AND PR.id = R.id_Propiedad
										WHERE R.estado = 0 AND P.id = @idMenor
										ORDER BY R.fecha ASC)
					IF @idRecibo IS NOT NULL 
						UPDATE [dbo].[Recibos]
						SET [estado] = 1
						WHERE [id] = @idRecibo
						
						SET @montoRecibo = (SELECT monto FROM [dbo].[Recibos] WHERE id = @idRecibo)
					
						--VERIFICA SI EXISTE COMPROBANTE DE PAGO
						SET @idComprobante = (SELECT CP.id
												FROM [dbo].[ComprobantePago] CP
												INNER JOIN [ReciboPagado] RP ON CP.id = RP.id_Comprobante
												INNER JOIN [dbo].[Recibos] R ON R.id = RP.id_Recibo 
												INNER JOIN @Pagos P ON P.idTipoRecibo = R.id_CC
												INNER JOIN [dbo].[Propiedad] PR ON P.numFinca = PR.numFinca AND R.id_Propiedad = PR.id
												WHERE CP.fecha = @fechaOperacion)
						/*IF @idComprobante IS NULL
							INSERT INTO [dbo].[ComprobantePago](fecha,total)
							SELECT @fechaOperacion,0
							SET @idComprobante = @@IDENTITY
							INSERT INTO [dbo].[ReciboPagado](id_Comprobante,id_Recibo)
							SELECT @idComprobante,@idRecibo

						--VERIFICA SI SE DEBE CREAR RECIBO MORATORIO
						SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] WHERE id = @idRecibo)
						IF @fechaVence <= @fechaOperacion
							SET @tasaMoratoria = (SELECT tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC INNER JOIN @Pagos P ON P.idTipoRecibo = CC.id)
							SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))
						
							INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
							SELECT 11,@montoMoratorio,1,PR.id,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
							FROM @Pagos P
							INNER JOIN [dbo].[Propiedad] PR ON P.numFinca = PR.numFinca
							INNER JOIN [dbo].[ConceptoDeCobro] CC ON p.idTipoRecibo = CC.id

							INSERT INTO [dbo].[ReciboPagado](id_Comprobante,id_Recibo)
							SELECT @idComprobante,@@IDENTITY

						UPDATE [dbo].[ComprobantePago]
						SET [total] = [total]+@montoRecibo+@montoMoratorio
						WHERE id = @idComprobante
						*/
					SET @idMenor = @idMenor+1
				END
			COMMIT
		/*END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 600021, 'Error: No se ha podido crear el pago.',1;
		END CATCH*/
	END
