USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcesaConsumo]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcesaConsumo]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcesaConsumo] @inConsumo ConsumoTipo READONLY
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @idMenor INT, @idMayor INT
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @inConsumo
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[MovConsumo](fecha,montoM3,lecturaConsumo,nuevoM3Consumo,id_Propiedad,idTipoMov)
					SELECT 
						C.Fecha,
						CASE WHEN (C.idTipo = 1) THEN C.LecturaM3-P.M3acumuladosAgua
						ELSE C.LecturaM3
						END,
						CASE WHEN (C.idTipo = 1) THEN C.LecturaM3
						ELSE NULL
						END,
						CASE WHEN (C.idTipo = 1) THEN C.LecturaM3
							 WHEN (C.idTipo = 2) THEN P.M3acumuladosAgua-C.LecturaM3
							 ELSE P.M3acumuladosAgua+C.LecturaM3
						END,
						P.id,
						C.idTipo
					FROM [dbo].[Propiedad] P
					INNER JOIN @inConsumo C ON C.numFinca = P.[numFinca]
					WHERE C.id = @idMenor

					UPDATE [Propiedad]
					SET M3acumuladosAgua = CASE WHEN (C.idTipo = 1) THEN C.LecturaM3
												WHEN (C.idTipo = 2) THEN M3acumuladosAgua-C.LecturaM3
												ELSE M3acumuladosAgua+C.LecturaM3
					END
					FROM [Propiedad] P
					INNER JOIN @inConsumo C ON C.numFinca = P.[numFinca]
					WHERE C.id = @idMenor

					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 92039, 'Error: no se ha podido procesar los consumos de agua.',1
		END CATCH;
	END
