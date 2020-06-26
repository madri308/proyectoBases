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
CREATE PROC [dbo].[SP_ProcesaConsumo] @consumo ConsumoTipo READONLY
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @idMenor INT, @idMayor INT
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @consumo
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[MovConsumo](fecha,montoM3,lecturaConsumo,nuevoM3Consumo,id_Propiedad,idTipoMov)
					SELECT 
						C.Fecha,
						Propiedad.M3acumuladosAgua-C.LecturaMedidorM3,
						LecturaMedidorM3,
						Propiedad.M3acumuladosAgua+Propiedad.M3acumuladosAgua-C.LecturaMedidorM3,
						Propiedad.id,
						2
					FROM [dbo].[Propiedad]
					INNER JOIN @consumo C ON C.numFinca = [dbo].[Propiedad].[numFinca]
					WHERE C.id = @idMenor

					UPDATE [Propiedad]
					SET M3acumuladosAgua = C.LecturaMedidorM3
					FROM [Propiedad]
					INNER JOIN @consumo C ON C.numFinca = [dbo].[Propiedad].[numFinca]
					WHERE C.id = @idMenor

					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 92039, 'Error: no se ha podido eliminar el usuario.',1
		END CATCH;
	END
