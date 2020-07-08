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
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @idMenor INT, @idMayor INT, @fechaVence DATE, @fechaOperacion DATE, @montoMoratorio MONEY, @contador INT,
					@idComprobante INT, @tasaMoratoria FLOAT, @montoRecibo MONEY, @tipoCC int, @idPropiedad INT
			DECLARE @idRecibosPagar TABLE(id INT IDENTITY(1,1),idRecibo INT, estado INT)
			SET @contador = 1
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @Pagos
			BEGIN TRAN
				WHILE @idMenor<=@idMayor--RECORRE LOS PAGOS DE FINCAS
				BEGIN
					SET @montoMoratorio = 0
					SET @fechaOperacion = (SELECT fechaOperacion FROM @Pagos WHERE id = @idMenor)
					SET @tipoCC = (SELECT idTipoRecibo FROM @Pagos WHERE id = @idMenor)
					SET @idPropiedad = (SELECT pr.id FROM [dbo].[Propiedad] PR INNER JOIN @Pagos P ON P.numFinca = PR.numFinca WHERE P.id = @idMenor)
					
					SET @idComprobante = (SELECT CC.id FROM [dbo].[ComprobantePago] CC 
															INNER JOIN [dbo].[ReciboPagado] RP ON RP.id_Comprobante = CC.id
															INNER JOIN [dbo].[Recibos] R ON R.id = RP.id
															WHERE R.id_Propiedad = @idPropiedad AND CC.fecha = @fechaOperacion)
					IF @idComprobante IS NULL
					BEGIN
						INSERT INTO [dbo].[ComprobantePago](fecha,total)
						SELECT @fechaOperacion,0
						SET @idComprobante = IDENT_CURRENT('[dbo].[ComprobantePago]')
					END
					--SI ES CONCEPTO DE COBRO 10 (RECONEXION)
					IF @tipoCC = 10
						BEGIN
							INSERT INTO @idRecibosPagar(idRecibo,estado)
							SELECT R.id,0
							FROM @Pagos P
							INNER JOIN [dbo].[Propiedad] PR ON PR.numFinca = P.numFinca 
							INNER JOIN [dbo].[Recibos] R ON R.id_Propiedad = PR.id
							WHERE P.id = @idMenor AND R.[estado] = 0
							AND (R.[id_CC] = 1	  --GUARDA TODOS LOS RECIBOS DE AGUA PENDIENTES (1)
								OR R.[id_CC] = 11 --GUARDA TODOS LOS RECIBOS MORATORIOS PENDIENTES (11)
								OR R.[id_CC] = 10)--GUARDA TODOS LOS RECIBOS DE RECONEXION PENDIENTES (10)
						END
					ELSE--SI ES OTRO CONCEPTO DE COBRO
						BEGIN
							INSERT INTO @idRecibosPagar(idRecibo,estado)
							SELECT R.id,0
							FROM @Pagos P
							INNER JOIN [dbo].[Propiedad] PR ON PR.numFinca = P.numFinca 
							INNER JOIN [dbo].[Recibos] R ON R.id_Propiedad = PR.id
							WHERE P.id = @idMenor AND R.[estado] = 0
							AND (R.[id_CC] = 11			--GUARDA TODOS LOS RECIBOS MORATORIOS PENDIENTES (11)
								OR	R.[id_CC] = @tipoCC)--GUARDA TODOS LOS RECIBOS DE DE ESE CONCEPTO DE COBRO PENDIENTES (@TIPOCC)
						END
					--MIENTRAS EXISTA UN CONCEPTO DE COBRO SIN PAGAR
					WHILE EXISTS(SELECT id FROM @idRecibosPagar WHERE estado = 0)--RECORRE LOS RECIBOS
					BEGIN
						SET @montoRecibo = (SELECT R.monto FROM [dbo].[Recibos] R
											INNER JOIN @idRecibosPagar idRP ON R.id = idRP.idRecibo
											WHERE idRP.id = @contador)

						INSERT INTO [dbo].[ReciboPagado](id_Comprobante,id_Recibo)
						SELECT @idComprobante,idRP.idRecibo
						FROM @idRecibosPagar idRP
						WHERE idRP.id = @contador

						UPDATE @idRecibosPagar
						SET estado = 1
						WHERE id = @contador

						UPDATE [dbo].[Recibos]
						SET [estado] = 1
						FROM @idRecibosPagar idRP
						WHERE idRP.idRecibo = [dbo].[Recibos].[id] AND idRP.id = @contador

						--VERIFICA SI SE DEBE CREAR RECIBO MORATORIO
						SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] R
										   INNER JOIN @idRecibosPagar idRP ON idRP.idRecibo = R.id
										   WHERE @contador = idRP.id)
						IF @fechaVence < @fechaOperacion
						BEGIN
							SET @tasaMoratoria = (SELECT CC.tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC
													INNER JOIN [dbo].[Recibos] R ON R.id_CC = CC.id 
													INNER JOIN  @idRecibosPagar idRP ON idRP.idRecibo = R.id
													WHERE idRP.id = @contador)

							SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))

							INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
							SELECT CC.id,@montoMoratorio,1,@idPropiedad,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
							FROM [dbo].[ConceptoDeCobro] CC
							WHERE CC.id = 11

							INSERT INTO [dbo].[ReciboPagado](id_Comprobante,id_Recibo)
							SELECT @idComprobante,IDENT_CURRENT('[dbo].[Recibos]')
						END
						UPDATE [dbo].[ComprobantePago]
						SET [total] = [total]+@montoRecibo+@montoMoratorio
						WHERE id = @idComprobante
						SET @contador = @contador+1
					END
					SET @idMenor = @idMenor+1
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW --600021, 'Error: No se ha podido crear los pago.',1;
		END CATCH
	END
