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
CREATE PROC [dbo].[SP_ProcReconexionAgua] @fecha DATE
AS  	
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			BEGIN TRAN
				
				/*SELECT id_Propiedad 
				FROM [dbo].[Recibos] R
				JOIN [dbo].[Propiedad] P ON R.id_Propiedad = P.id
				WHERE EXISTS(SELECT 2 FROM [dbo].[Recibos] WHERE id_Propiedad = P.id AND id_CC = 1)*/
				DECLARE @idPropiedades TABLE(id INT IDENTITY(1,1),idPropiedad int)
				DECLARE @idMenor INT, @idMayor INT

				INSERT INTO @idPropiedades(idPropiedad)
				SELECT P.id
				FROM [dbo].[Propiedad] P
				INNER JOIN [dbo].[Recibos] R ON P.id = R.id_Propiedad AND (R.id_CC = 1 OR R.id_CC = 10)
				WHERE P.id = ALL(SELECT R.id_Propiedad WHERE R.estado = 1)

				SELECT @idMenor = MIN(id), @idMayor = MAX(id) FROM @idPropiedades
				
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[Reconexion](fecha,id_Propiedad,recRecon)
					SELECT @fecha,idP.idPropiedad,R.id
					FROM @idPropiedades idP
					INNER JOIN [dbo].[Recibos] R ON R.id_Propiedad = idP.idPropiedad
					WHERE idP.id = @idMenor
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 55004,'Error: No se ha podido eliminar el propietario',1;
		END CATCH	
	END
