USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcCortaAgua]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcCortaAgua]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcCortaAgua] @fecha DATE
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
				DECLARE @idPropiedades TABLE(id INT IDENTITY(1,1),idPropiedad int,c int)
				DECLARE @idMenor INT, @idMayor INT

				INSERT INTO @idPropiedades
				SELECT id_Propiedad, COUNT(*)
				FROM [dbo].[Recibos] 
				WHERE estado = 0
				GROUP BY id_Propiedad
				HAVING COUNT(*) > 1

				SELECT @idMenor = MIN(id), @idMayor = MAX(id) FROM @idPropiedades
				
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
					SELECT 10,CC.monto,0,P.idPropiedad,@fecha,DATEADD(D,CC.diasParaVencer,@fecha)
					FROM @idPropiedades P
					INNER JOIN [dbo].[ConceptoDeCobro] CC ON CC.id = 10
					WHERE P.id = @idMenor

					INSERT INTO [dbo].[ReciboReconexion](id)
					SELECT @@IDENTITY

					INSERT INTO [dbo].[Reconexion](fecha,id_Propiedad,recRecon)
					SELECT @fecha,idP.idPropiedad,@@IDENTITY
					FROM @idPropiedades idP
					WHERE idP.id =	@idMenor
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 55004,'Error: No se ha podido eliminar el propietario',1;
		END CATCH	
	END
