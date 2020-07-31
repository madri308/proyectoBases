USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ConsultarCuota]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ConsultarCuota]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ConsultarCuota] @inIdRecibos TablaRecibosAPagarTipo READONLY, @inMeses INT
AS 
	BEGIN
		BEGIN TRY
			DECLARE 
			@idMenor INT
			,@idMayor INT
			,@sumaRecibos MONEY = 0
			,@cuota MONEY
			,@tasaInteres FLOAT
			,@montoMoratorio MONEY
			,@fechaOperacion DATE
			,@idPropiedad INT
			,@fechaVence DATE
			,@montoRecibo MONEY
			,@tasaMoratoria FLOAT

			--GUARDA LOS IDS DE LOS RECIBOS QUE QUIERO PAGAR
			INSERT INTO idRecibosPagarAP(idRecibo)
			SELECT idRecibo
			from @inIdRecibos

			--SACA ID MAYOR Y MENOR PARA ITERAR LA TABLA
			SELECT @idMenor = MIN([id]), @idMayor=MAX([id]) FROM idRecibosPagarAP
			BEGIN TRAN
				WHILE @idMenor<=@idMayor--RECORRE LOS RECIBOS
				BEGIN
					SET @montoMoratorio = 0
					SET @fechaOperacion = GETDATE()
					SET @idPropiedad = (SELECT id_Propiedad FROM [Recibos] R 
											INNER JOIN idRecibosPagarAP idRP ON idRP.idRecibo = R.id
											WHERE @idMenor = idRP.id)
					SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] R
											INNER JOIN idRecibosPagarAP idRP ON idRP.idRecibo = R.id
											WHERE @idMenor = idRP.id)
					SET @montoRecibo = (SELECT R.monto FROM [dbo].[Recibos] R
											INNER JOIN idRecibosPagarAP idRP ON R.id = idRP.idRecibo
											WHERE idRP.id = @idMenor)
					IF @fechaVence < @fechaOperacion
					BEGIN
						--SACA LA TASA MORATORIA DEL RECIBO
						SET @tasaMoratoria = (SELECT CC.tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC
												INNER JOIN [dbo].[Recibos] R ON R.id_CC = CC.id 
												INNER JOIN  idRecibosPagarAP idRP ON idRP.idRecibo = R.id
												WHERE idRP.id = @idMenor)

						--AQUI CAMBIA EL MONTO MORATORIO YA QUE SI SE DEBE CREAR RECIBO MORATORIO
						SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))
						
						--CREA UN RECIBO DE TIPO MORATORIO
						INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
						SELECT CC.id,@montoMoratorio,3,@idPropiedad,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
						FROM [dbo].[ConceptoDeCobro] CC
						WHERE CC.id = 11

						--GUARDA ADEMAS LOS RECIBOS MORATORIOS A PAGAR
						INSERT INTO idRecibosPagarAP(idRecibo)
						SELECT IDENT_CURRENT('[dbo].[Recibos]')
					END
					SET @sumaRecibos += @montoMoratorio+@montoRecibo
					SET @idMenor += 1
				END
			COMMIT
			SET @tasaInteres = (CONVERT(FLOAT,(SELECT valor FROM [dbo].[ValoresConfig] WHERE id = 1)) / 12) /100
			SET @cuota = @sumaRecibos*((@tasaInteres*POWER((1+@tasaInteres),@inMeses))/(POWER((1+@tasaInteres),@inMeses)-1))
			--SELECT @cuota

			SELECT @cuota,R.[id_CC],R.[monto],R.[fecha],R.[fechaVence] FROM [dbo].[Recibos] R
			INNER JOIN idRecibosPagarAP RP ON R.id = RP.idRecibo
			ORDER BY [fecha]


		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 55501,'Error no hemos podido generar la cuota.',1;
		END CATCH
	END
