USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcActualizarValProp]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcActualizarValProp]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcActualizarValProp] @inNuevosValProp ValorPropiedadTipo READONLY, @inFecha DATE
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @idMenor INT, @idMayor INT
			SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @inNuevosValProp
			BEGIN TRAN
				WHILE @idMenor<=@idMayor
				BEGIN
					UPDATE [dbo].[Propiedad]
					SET [dbo].[Propiedad].[valor] = NVP.nuevoValor,
						[dbo].[Propiedad].[fechaDeIngreso] = @inFecha
					FROM [dbo].[Propiedad] P
					INNER JOIN @inNuevosValProp NVP ON NVP.numFinca = P.numFinca
					WHERE NVP.id = @idMenor
			
					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 600210, 'Error: No se ha podido actualizar la propiedad.',1;
		END CATCH
	END
