USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_RecibosSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_RecibosSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_RecibosSelect] 
    @inNumFinca varchar(100), @inOpcionRecibos int
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @idPropiedad INT
			SET @idPropiedad = (SELECT id FROM Propiedad WHERE Propiedad.numFinca = @inNumFinca)

			SELECT R.[id]
				,R.[id_CC]
				,R.[monto]
				,R.[estado]
				,R.[fecha]
				,R.[fechaVence]
				,RAP.[descripcion]
				,RAP.[idMovAP]
			FROM   [dbo].[Recibos] R
			LEFT OUTER JOIN [dbo].[RecibosAP] RAP ON R.id = RAP.id
			WHERE  [id_Propiedad] = @idPropiedad 
			AND [estado] = @inOpcionRecibos
		END TRY
		BEGIN CATCH
			THROW 63857,'Error: No se ha podido mostrar los recibos.',1;
		END CATCH
	END
