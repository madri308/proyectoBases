USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_pagarRecibos]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_pagarRecibos]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[
 --{ "id" : 2},
 --{ "id" : 5}

--]
CREATE PROC [dbo].[SP_pagarRecibos] @inIdRecibos TablaRecibosAPagarTipo READONLY
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @idMenor INT, @idMayor INT, @montoRecibo MONEY, 
					@montoMoratorio MONEY,@fechaOperacion DATE, @montoTotal MONEY,
					@fechaVence DATE, @tasaMoratoria FLOAT,@idPropiedad int
			--GUARDA LOS IDS DE LOS RECIBOS QUE QUIERO PAGAR
			INSERT INTO idRecibosPagarTable(idRecibo)
			SELECT idRecibo
			FROM @inIdRecibos

			SET @montoTotal = 0

			SELECT @idMenor = MIN([id]), @idMayor=MAX([id]) FROM idRecibosPagarTable--SACA ID MAYOR Y MENOR PARA ITERAR LA TABLA
			BEGIN TRAN
				WHILE @idMenor<=@idMayor--RECORRE LOS RECIBOS
				BEGIN
					SET @montoMoratorio = 0
					SET @fechaOperacion = GETDATE()
					SET @idPropiedad = (SELECT id_Propiedad FROM [Recibos] R 
											INNER JOIN idRecibosPagarTable idRP ON idRP.idRecibo = R.id
											WHERE @idMenor = idRP.id)
					SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] R
										   INNER JOIN idRecibosPagarTable idRP ON idRP.idRecibo = R.id
										   WHERE @idMenor = idRP.id)
					SET @montoRecibo = (SELECT R.monto FROM [dbo].[Recibos] R
											INNER JOIN idRecibosPagarTable idRP ON R.id = idRP.idRecibo
											WHERE idRP.id = @idMenor)
					IF @fechaVence < @fechaOperacion
					BEGIN
						--SACA LA TASA MORATORIA DEL RECIBO
						SET @tasaMoratoria = (SELECT CC.tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC
												INNER JOIN [dbo].[Recibos] R ON R.id_CC = CC.id 
												INNER JOIN  idRecibosPagarTable idRP ON idRP.idRecibo = R.id
												WHERE idRP.id = @idMenor)

						--AQUI CAMBIA EL MONTO MORATORIO YA QUE SI SE DEBE CREAR RECIBO MORATORIO
						SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))
						
						--CREA UN RECIBO DE TIPO MORATORIO
						INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
						SELECT CC.id,@montoMoratorio,0,@idPropiedad,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
						FROM [dbo].[ConceptoDeCobro] CC
						WHERE CC.id = 11

						--GUARDA ADEMAS LOS RECIBOS MORATORIOS A PAGAR
						INSERT INTO idRecibosPagarTable(idRecibo)
						SELECT IDENT_CURRENT('[dbo].[Recibos]')
					END
					SET @montoTotal += @montoMoratorio+@montoRecibo
					SET @idMenor += 1
				END
			COMMIT
			SELECT [id_CC],[monto],[fecha],[fechaVence] FROM [dbo].[Recibos] R
			INNER JOIN idRecibosPagarTable RP ON R.id = RP.idRecibo
			ORDER BY [fecha]
		END TRY
		BEGIN CATCH
			THROW 92039, 'Error: no se ha podido calcular el total.',1
		END CATCH;
	END
