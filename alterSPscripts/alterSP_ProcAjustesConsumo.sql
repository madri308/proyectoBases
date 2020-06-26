USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcAjustesConsumo]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcAjustesConsumo]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcAjustesConsumo] @ajustesConsumo AjustesConsumoTipo READONLY
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @idMenor INT, @idMayor INT
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @ajustesConsumo
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[MovConsumo](fecha,montoM3,lecturaConsumo,nuevoM3Consumo,id_Propiedad,idTipoMov)
					SELECT AC.Fecha,AC.M3,NULL,Propiedad.M3acumuladosAgua+AC.M3,Propiedad.id,1
					FROM [dbo].[Propiedad]
					INNER JOIN @ajustesConsumo AC ON AC.numFinca = [dbo].[Propiedad].[numFinca]
					WHERE AC.id = @idMenor

					UPDATE [Propiedad]
					SET M3acumuladosAgua = M3acumuladosAgua+AC.M3
					FROM [Propiedad]
					INNER JOIN @ajustesConsumo AC ON AC.numFinca = [dbo].[Propiedad].[numFinca]
					WHERE AC.id = @idMenor

					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 92039, 'Error: no se ha podido eliminar el usuario.',1
		END CATCH;
	END
