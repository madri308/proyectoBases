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
CREATE PROC [dbo].[SP_ProcCortaAgua] @inFecha DATE
AS  	
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idPropiedades TABLE(id INT IDENTITY(1,1),idPropiedad int,idCC INT,c int)
			DECLARE @idMenor INT, @idMayor INT, @id int
			BEGIN TRAN
				INSERT INTO @idPropiedades(idPropiedad,idCC,c)
				SELECT R.id_Propiedad,R.id_CC, COUNT(*)
				FROM [dbo].[Recibos] R
				WHERE R.estado = 0 AND R.id_CC = 1
				AND NOT EXISTS (SELECT id FROM [dbo].[Recibos] WHERE id_CC = 10 AND id_Propiedad = R.id_Propiedad)
				GROUP BY id_Propiedad,R.id_CC
				HAVING COUNT(*) > 1
				
				SELECT @idMenor = MIN(id), @idMayor = MAX(id) FROM @idPropiedades
				
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
					SELECT 10,CC.monto,0,P.idPropiedad,@inFecha,DATEADD(D,CC.diasParaVencer,@inFecha)
					FROM @idPropiedades P
					INNER JOIN [dbo].[ConceptoDeCobro] CC ON CC.id = 10
					WHERE P.id = @idMenor

					SET @id = IDENT_CURRENT('[dbo].[Recibos]')

					INSERT INTO [dbo].[ReciboReconexion](id)
					SELECT @id

					INSERT INTO [dbo].[Corte](fecha,id_Propiedad,recRecon)
					SELECT @inFecha,idP.idPropiedad,@id
					FROM @idPropiedades idP
					WHERE idP.id =	@idMenor
					
					SET @idMenor = @idMenor+1
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 554004,'Error: No se ha podido procesas las cortas de agua',1;
		END CATCH	
	END
