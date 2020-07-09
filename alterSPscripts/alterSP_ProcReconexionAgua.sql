USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcReconexionAgua]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcReconexionAgua]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcReconexionAgua] @inFecha DATE
AS  	
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idPropiedades TABLE(id INT IDENTITY(1,1),idPropiedad int)
			DECLARE @idMenor INT, @idMayor INT
			BEGIN TRAN
				INSERT INTO @idPropiedades(idPropiedad)
				SELECT DISTINCT R.id_Propiedad
				FROM [dbo].[Recibos] R
				WHERE 1 = ALL(SELECT estado FROM [dbo].[Recibos] WHERE id_Propiedad = R.id_Propiedad)
				AND NOT EXISTS(SELECT * FROM [dbo].[Reconexion] WHERE id_Propiedad = R.id_Propiedad)
				AND EXISTS(SELECT * FROM [dbo].[Corte] WHERE id_Propiedad = R.id_Propiedad)
				AND (R.id_CC = 1 OR R.id_CC = 10)

				SELECT @idMenor = MIN(id), @idMayor = MAX(id) FROM @idPropiedades
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[Reconexion](fecha,id_Propiedad,recRecon)
					SELECT @inFecha,idP.idPropiedad,R.id
					FROM @idPropiedades idP
					INNER JOIN [dbo].[Recibos] R ON R.id_Propiedad = idP.idPropiedad
					WHERE idP.id = @idMenor AND R.id_CC = 10
					SET @idMenor = @idMenor+1
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 55004,'Error: No se ha podido procesar reconexiones',1;
		END CATCH	
	END
