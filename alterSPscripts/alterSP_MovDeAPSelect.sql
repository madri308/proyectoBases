USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_MovDeAPSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_MovDeAPSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MovDeAPSelect] @inAPid varchar(100)
AS
	BEGIN
		BEGIN TRY
			SELECT * 
			FROM [dbo].[MovimientosAP] MAP
			INNER JOIN [dbo].[ArregloPago] AP ON MAP.idAP = AP.id
			WHERE AP.id = @inAPid 
		END TRY
		BEGIN CATCH
			THROW 55200, 'Error: No se ha podido encontrar propiedad del propietario',1;
		END CATCH
	END
