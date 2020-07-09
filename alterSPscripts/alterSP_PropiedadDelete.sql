USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelete] 
    @inNumFinca varchar(30)
AS   
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			UPDATE [dbo].[Propiedad]
			SET    [activo] = 0,
				[fechaDeIngreso] = GETDATE()
			WHERE  [numFinca] = @inNumFinca
		END TRY
		BEGIN CATCH
			THROW 69023,'Error: No se ha podido eliminar la propiedad.',1;
		END CATCH
	END
