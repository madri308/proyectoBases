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
			DECLARE @idMenor INT, @idMayor INT, @idRecibo INT, @fechaVence DATE, @fechaOperacion DATE, @montoMoratorio MONEY,
					@idComprobante INT, @tasaMoratoria FLOAT, @montoRecibo MONEY
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @Pagos
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					--PAGA EL RECIBO MAS VIEJO PENDIENTE CORRESPONDIENTE AL CONCEPTO DE COBRO.
					SET @idRecibo = (SELECT R.id 
										FROM [dbo].[Recibos] R
										INNER JOIN @Pagos P ON P.idTipoRecibo = R.id_CC
										WHERE R.fecha = (SELECT min(fecha) FROM [dbo].[Recibos] WHERE estado = 0) 
										AND P.id = @idMenor)
					UPDATE [dbo].[Recibos]
					SET [estado] = 1
					WHERE [id] = @idRecibo

					SET @montoRecibo = (SELECT monto FROM [dbo].[Recibos] WHERE id = @idRecibo)

					--VERIFICA SI SE DEBE CREAR RECIBO MORATORIO
					SET @fechaVence = (SELECT fechaVence FROM [dbo].[Recibos] WHERE id = @idRecibo)
					SET @fechaOperacion = (SELECT fechaOperacion FROM @Pagos WHERE id = @idMenor)
					--------------Verifica si existe un comprobante para este dia y sino lo crea
					SET @idComprobante = (SELECT id FROM [dbo].[ComprobantePago] WHERE fecha = @fechaOperacion)
					IF @idComprobante IS NULL
						INSERT INTO [dbo].[ComprobantePago](fecha,total)
						SELECT @fechaOperacion,0
					SET @idComprobante = (SELECT id FROM [dbo].[ComprobantePago] WHERE fecha = @fechaOperacion)
					SET @montoMoratorio = 0
					IF @fechaVence <= @fechaOperacion
						SET @tasaMoratoria = (SELECT tasaImpuestoMoratorio FROM [dbo].[ConceptoDeCobro] CC INNER JOIN @Pagos P ON P.idTipoRecibo = CC.id)
						SET @montoMoratorio = (@montoRecibo*@tasaMoratoria/365)*ABS(DATEDIFF(d,@fechaVence,@fechaOperacion))
					
						INSERT INTO [dbo].[Recibos](id_CC,id_Comprobante,monto,estado,id_Propiedad,fecha,fechaVence)
						SELECT 11,@idComprobante,@montoMoratorio,1,PR.id,@fechaOperacion,DATEADD(d,CC.diasParaVencer,@fechaOperacion)
						FROM @Pagos P
						INNER JOIN [dbo].[Propiedad] PR ON P.numFinca = PR.numFinca
						INNER JOIN [dbo].[ConceptoDeCobro] CC ON p.idTipoRecibo = CC.id
					UPDATE [dbo].[ComprobantePago]
					SET [total] = [total]+@montoRecibo+@montoMoratorio
					FROM [dbo].[ComprobantePago] CP
					INNER JOIN [dbo].[Recibos] R ON R.id_CC = CP.id
					WHERE R.id = @idRecibo

					SET @idMenor = @idMenor+1
				END
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 6000, 'Error: No se ha podido crear el pago.',1;
		END CATCH
	END
