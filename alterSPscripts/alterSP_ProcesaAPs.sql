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
		DECLARE @idRecibosAP TABLE(id INT IDENTITY(1,1),idRecibo INT,visitado INT);
		DECLARE 
		@idMenor INT
		,@idMayor INT
		,@idPropiedad INT
		,@meses INT
		,@cuota INT
		,@indice INT = 0
		,@fechaVence DATE
		,@tasaMoratoria FLOAT
		,@montoMoratorio MONEY
		,@montoRecibo MONEY
		,@montoAP MONEY
		,@tasaInteres FLOAT
			BEGIN TRAN
				SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @APs
				--PRIMERO ITERO POR LAS PROPIEDADES PARA GENERAR APS
				WHILE @idMenor<=@idMayor
				BEGIN
					SET @montoAP = 0
					SET @idPropiedad = (SELECT P.id
										FROM @APs APs
										INNER JOIN [dbo].[Propiedad] P ON P.numFinca = APs.numFinca 
										WHERE APs.id = @idMenor)
					SET @meses = (SELECT plazo 
									FROM @APs
									WHERE id = @idMenor)

					--GUARDO TODOS LOS RECIBOS PENDIENTES
					INSERT INTO @idRecibosAP(idRecibo,visitado)
					SELECT R.id,0
					FROM [dbo].[Recibos] R
					WHERE R.estado = 0 AND R.id_Propiedad = @idPropiedad

					--WHILE PARA RECORRER LOS RECIBOS Y VERIFICAR SI ES NECESARIO CREAR MORATORIOS
					--SI ES NECESARIO ENTONCES LOS GUARDO EN LA TABLA DE IDS
					WHILE EXISTS(SELECT * FROM @idRecibosAP WHERE visitado = 0)
					BEGIN
						--PONE EL RECIBO COMO VISITADO PORQUE LO ESTAMOS VISITANDO EN ESTE MOMENTO
						UPDATE @idRecibosAP
						SET visitado = 1
						WHERE id = @indice

						SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] R
										   INNER JOIN @idRecibosAP idRAP ON idRAP.idRecibo = R.id
										   WHERE @indice = idRAP.id AND idRAP.visitado = 0)
						SET @montoRecibo = (SELECT R.monto FROM [dbo].[Recibos] R
											INNER JOIN @idRecibosAP idRAP ON R.id = idRAP.idRecibo
											WHERE @indice = idRAP.id AND idRAP.visitado = 0)
						SET @montoAP += @montoRecibo
						IF @fechaVence < @fechaOperacion
						BEGIN
							--SACA LA TASA MORATORIA DEL RECIBO
							SET @tasaMoratoria = (SELECT CC.tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC
													INNER JOIN [dbo].[Recibos] R ON R.id_CC = CC.id 
													INNER JOIN  @idRecibosAP idRAP ON idRAP.idRecibo = R.id
													WHERE @indice = idRAP.id AND idRAP.visitado = 0)

							SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))
							SET @montoAP += @montoMoratorio
							--CREA UN RECIBO DE TIPO MORATORIO
							INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
							SELECT CC.id,@montoMoratorio,0,@idPropiedad,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
							FROM [dbo].[ConceptoDeCobro] CC
							WHERE CC.id = 11

							--GUARDA ADEMAS LOS RECIBOS MORATORIOS A PAGAR
							INSERT INTO @idRecibosAP(idRecibo,visitado)
							SELECT IDENT_CURRENT('[dbo].[Recibos]'),1
							
							SET @indice += 1 --INCREMENTO EN INDICE PARA IR GUARANDO POR DONDE VOY 
						END
					END
					--GENERO EL AP
					SET @tasaInteres = convert(float,(SELECT valor FROM [dbo].[ValoresConfig] WHERE nombre = 'TasaInteres AP'))
					SET @cuota = @montoAP*((@tasaInteres*POWER((1+@tasaInteres),@meses))/(POWER((1+@tasaInteres),@meses)-1))

					--PODRIA LLAMAR AL SP PARA CREAR APs PERO TENDRIA QUE GUARDAR LOS IDS EN LA TABLA TEMPORAL

					--CREAR EL AP AQUI MISMO 

					SET @idMenor += 1
				END
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 600021, 'Error: No se ha podido procesar los arreglos de pago.',1;
		END CATCH
	END
