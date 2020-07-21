USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ComprobantePagoPorPropiedadSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ComprobantePagoPorPropiedadSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoPorPropiedadSelect] 
	@inNumFinca INT
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			SELECT DISTINCT CP.id,CP.fecha, CP.total 
			FROM   [dbo].[ComprobantePago] CP
			INNER JOIN [dbo].[ReciboPagado] RP ON RP.id_Comprobante = CP.id
			INNER JOIN [dbo].[Recibos] R ON R.id = RP.id_Recibo
			INNER JOIN [dbo].[Propiedad] P ON P.id = R.id_Propiedad
			WHERE P.numFinca = @inNumFinca
			ORDER BY CP.fecha
		END TRY
		BEGIN CATCH
			THROW 533901,'Error: No se ha podido mostrar comprobante de pago de la propiedad.',1;
		END CATCH
	END
