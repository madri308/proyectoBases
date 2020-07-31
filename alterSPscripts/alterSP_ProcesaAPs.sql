USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcesaAPs]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcesaAPs]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcesaAPs] @APs APTipo READONLY, @fechaOperacion DATE
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
		DECLARE 
		@idMenor INT
		,@idMayor INT
		,@idPropiedad INT
		,@meses INT
		,@cuota INT
		,@fechaVence DATE
		,@tasaMoratoria FLOAT
		,@montoMoratorio MONEY
		,@montoRecibo MONEY
		,@montoAP MONEY
		,@tasaInteres FLOAT
		,@idMenorRecibo INT
		,@idMayorRecibo INT	
		SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @APs
			BEGIN TRAN	
				--PRIMERO ITERO POR LAS PROPIEDADES PARA OBTENER LOS RECIBOS
				WHILE @idMenor<=@idMayor
				BEGIN
					SET @montoAP = 0--MONTO TOTAL DEL AP

					--DATOS QUE VIENEN EN LA TABLA INPUT
					SET @idPropiedad = (SELECT P.id
										FROM @APs APs
										INNER JOIN [dbo].[Propiedad] P ON P.numFinca = APs.numFinca 
										WHERE APs.id = @idMenor)
					SET @meses = (SELECT plazo 
									FROM @APs
									WHERE id = @idMenor)
					
					--GUARDO TODOS LOS RECIBOS PENDIENTES
					INSERT INTO idRecibosPagarAP(idRecibo)
					SELECT R.id
					FROM [dbo].[Recibos] R
					WHERE R.estado = 0 AND R.id_Propiedad = @idPropiedad
					--WHILE PARA RECORRER LOS RECIBOS Y VERIFICAR SI ES NECESARIO CREAR MORATORIOS
					--SI ES NECESARIO ENTONCES LOS GUARDO EN LA TABLA DE RECIBOS PENDIENTES
					SELECT @idMenorRecibo = MIN([id]), @idMayorRecibo=MAX([id]) FROM idRecibosPagarAP--SACA ID MAYOR Y MENOR PARA ITERAR LA TABLA
					WHILE @idMenorRecibo <= @idMayorRecibo
					BEGIN
						SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] R
										   INNER JOIN idRecibosPagarAP idRAP ON idRAP.idRecibo = R.id
										   WHERE @idMenorRecibo = idRAP.id)
						SET @montoRecibo = (SELECT R.monto FROM [dbo].[Recibos] R
											INNER JOIN idRecibosPagarAP idRAP ON R.id = idRAP.idRecibo
											WHERE @idMenorRecibo = idRAP.id)
						SET @montoAP += @montoRecibo
						IF @fechaVence < @fechaOperacion
						BEGIN
							--SACA LA TASA MORATORIA DEL RECIBO
							SET @tasaMoratoria = (SELECT CC.tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC
													INNER JOIN [dbo].[Recibos] R ON R.id_CC = CC.id 
													INNER JOIN  idRecibosPagarAP idRAP ON idRAP.idRecibo = R.id
													WHERE @idMenorRecibo = idRAP.id)

							SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))
							SET @montoAP += @montoMoratorio

							--CREA UN RECIBO DE TIPO MORATORIO
							INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
							SELECT CC.id,@montoMoratorio,0,@idPropiedad,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
							FROM [dbo].[ConceptoDeCobro] CC
							WHERE CC.id = 11

							--GUARDA ADEMAS LOS RECIBOS MORATORIOS A PAGAR
							INSERT INTO idRecibosPagarAP(idRecibo)
							SELECT IDENT_CURRENT('[dbo].[Recibos]')	
						END
						SET @idMenorRecibo += 1
					END
					--GENERO EL AP
					SET @tasaInteres = (CONVERT(FLOAT,(SELECT valor FROM [dbo].[ValoresConfig] WHERE id = 1))/12)/100
					SET @cuota = @montoAP*((@tasaInteres*POWER((1+@tasaInteres),@meses))/(POWER((1+@tasaInteres),@meses)-1))

					--LLAMA AL SP QUE ME CREA APs
					EXEC [dbo].[SP_CrearAP] @meses,@cuota

					SET @idMenor += 1
				END
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			--THROW 600021, 'Error: No se ha podido procesar los arreglos de pago.',1;
		END CATCH
	END
