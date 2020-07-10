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
			--TABLA DE IDS DE RECIBOS POR CONCEPTO DE COBRO DE CADA PROPIEDAD 
			DECLARE @idRecibosPagar TABLE(id INT IDENTITY(1,1),idRecibo INT)
			--CONTADOR PARA ITERAR TABLA DE RECIBOS DE CADA PROPIEDAD Y SABER DONDE QUEDE LA ULTIMA VEZ
			SET @contador = 1
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @Pagos--SACA ID MAYOR Y MENOR PARA ITERAR LA TABLA
			BEGIN TRAN
				--RECORRE LOS PAGOS DE FINCAS
				WHILE @idMenor<=@idMayor
				BEGIN
					SET @montoMoratorio = 0 --MONTO MORATORIO SE CAMBIA SI ES QUE HAY RECIBO MORATORIO, SINO ES 0
					SET @fechaOperacion = (SELECT fechaOperaciones FROM @Pagos WHERE id = @idMenor)
					SET @tipoCC = (SELECT idTipoRecibo FROM @Pagos WHERE id = @idMenor)--TIPO CC EN EL PAGO
					SET @idPropiedad = (SELECT pr.id FROM [dbo].[Propiedad] PR --PROPIEDAD A LA QUE SE LE HACE EL PAGO
										INNER JOIN @Pagos P ON P.numFinca = PR.numFinca 
										WHERE P.id = @idMenor)
					
					--VERIFICA SI EXISTE EL COMPROBANTE DE PAGO PARA ESA PROPIEDAD, ESE MISMO DIA
					SET @idComprobante = (SELECT CC.id FROM [dbo].[ComprobantePago] CC 
												INNER JOIN [dbo].[ReciboPagado] RP ON RP.id_Comprobante = CC.id
												INNER JOIN [dbo].[Recibos] R ON R.id = RP.id_Recibo
												WHERE R.id_Propiedad = @idPropiedad AND CC.fecha = @fechaOperacion)
					--SI NO EXISTE ENTONCES LO CREA
					IF @idComprobante IS NULL
					BEGIN
						INSERT INTO [dbo].[ComprobantePago](fecha,total)
						SELECT @fechaOperacion,0
						SET @idComprobante = IDENT_CURRENT('[dbo].[ComprobantePago]')
					END
					
					--SE INSERTAN LOS RECIBOS DE LA PROPIEDAD EN LA TABLA VARIABLE, Y SE VAN ACUMULANDO, PARA ESO SE USA EL CONTADOR
					--SI ES CONCEPTO DE COBRO 10 (RECONEXION)
					IF @tipoCC = 10
						BEGIN
							INSERT INTO @idRecibosPagar(idRecibo)
							SELECT R.id
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
							INSERT INTO @idRecibosPagar(idRecibo)
							SELECT R.id
							FROM @Pagos P
							INNER JOIN [dbo].[Propiedad] PR ON PR.numFinca = P.numFinca 
							INNER JOIN [dbo].[Recibos] R ON R.id_Propiedad = PR.id
							WHERE P.id = @idMenor AND R.[estado] = 0
							AND (R.[id_CC] = 11			--GUARDA TODOS LOS RECIBOS MORATORIOS PENDIENTES (11)
								OR	R.[id_CC] = @tipoCC)--GUARDA TODOS LOS RECIBOS DE DE ESE CONCEPTO DE COBRO PENDIENTES (@TIPOCC)
						END
					
					--MIENTRAS EXISTA UN CONCEPTO DE COBRO SIN PAGAR, RECORRA LOS RECIBOS
					WHILE EXISTS(SELECT idRP.id FROM @idRecibosPagar idRP INNER JOIN [dbo].[Recibos] R ON R.id = idRP.idRecibo WHERE R.estado = 0)
					BEGIN
						--ESTABLECE EL MONTO DEL RECIBO
						SET @montoRecibo = (SELECT R.monto FROM [dbo].[Recibos] R
											INNER JOIN @idRecibosPagar idRP ON R.id = idRP.idRecibo
											WHERE idRP.id = @contador)

						--INSERTA UNA RELACION ENTRE RECIBO Y COMPROBANTE DE PAGO
						INSERT INTO [dbo].[ReciboPagado](id_Comprobante,id_Recibo)
						SELECT @idComprobante,idRP.idRecibo
						FROM @idRecibosPagar idRP
						WHERE idRP.id = @contador

						--PAGA EL RECIBO ACTUALIZANDO SU ESTADO A PAGADO
						UPDATE [dbo].[Recibos]
						SET [estado] = 1
						FROM @idRecibosPagar idRP
						WHERE idRP.idRecibo = [dbo].[Recibos].[id] AND idRP.id = @contador

						--VERIFICA SI SE DEBE CREAR RECIBO MORATORIO
						--SACA LA FECHA EN LA QUE VENCE EL RECIBO
						SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] R
										   INNER JOIN @idRecibosPagar idRP ON idRP.idRecibo = R.id
										   WHERE @contador = idRP.id)
						--SI LA FECHA EN LA QUE VENCE ES MENOR A LA FECHA EN LA QUE SE ESTA PAGANDO EL RECIBO
						IF @fechaVence < @fechaOperacion
						BEGIN
							--SACA LA TASA MORATORIA DE ESE RECIBO
							SET @tasaMoratoria = (SELECT CC.tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC
													INNER JOIN [dbo].[Recibos] R ON R.id_CC = CC.id 
													INNER JOIN  @idRecibosPagar idRP ON idRP.idRecibo = R.id
													WHERE idRP.id = @contador)
							--AQUI CAMBIA EL MONTO MORATORIO YA QUE SI SE DEBE CREAR RECIBO MORATORIO
							SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))
							
							--CREA UN RECIBO RE TIPO MORATORIO Y LO PAGA
							INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
							SELECT CC.id,@montoMoratorio,1,@idPropiedad,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
							FROM [dbo].[ConceptoDeCobro] CC
							WHERE CC.id = 11
							
							--INSERTAR UNA RELACION ENTRE EL RECIBO MORATORIO PAGADO Y EL COMPROBANTE DE PAGO
							INSERT INTO [dbo].[ReciboPagado](id_Comprobante,id_Recibo)
							SELECT @idComprobante,IDENT_CURRENT('[dbo].[Recibos]')	
						END
						--AL FINAL ACTUALIZA EL MONTO DEL COMPORBANTE DE PAGO
						UPDATE [dbo].[ComprobantePago]
						SET [total] = [total]+@montoRecibo+@montoMoratorio--SI NO HUBO RECIBO MORATORIO SUMA 0 MAS EL MONTO POR LOS DEMAS RECIBOS
						WHERE id = @idComprobante
						SET @contador = @contador+1--INCREMENTA EL CONTADOR
					END
					SET @idMenor = @idMenor+1
				END
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW --600021, 'Error: No se ha podido crear los pago.',1;
		END CATCH
	END
