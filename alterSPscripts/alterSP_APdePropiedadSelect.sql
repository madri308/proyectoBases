USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_APdeUsuarioSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_APdeUsuarioSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_APdeUsuarioSelect] @inNumFinca varchar(100)
AS
	BEGIN
		BEGIN TRY
			SELECT * 
			FROM [dbo].[ArregloPago] AP
			INNER JOIN [dbo].[Propiedad] P ON P.id = AP.IdPropiedad
			WHERE P.numFinca = @inNumFinca 
		END TRY
		BEGIN CATCH
			THROW 55200, 'Error: No se ha podido encontrar propiedad del propietario',1;
		END CATCH
	END
