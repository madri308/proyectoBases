USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_getCCdePropiedad]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_getCCdePropiedad]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_getCCdePropiedad] @inNumfinca VARCHAR(30)
AS
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON;
			DECLARE @idFinca INT
			SET @idFinca = (	SELECT [id]
								FROM [dbo].[Propiedad] 
								WHERE [numFinca] = @inNumfinca AND [activo] = 1)
			SELECT *
			FROM [CCdePropiedadView]
			WHERE [id_Propiedad] = @idFinca 
		END TRY
		BEGIN CATCH
			THROW 66900,'Error: No se han podido mostrar los conceptos de cobro de la propiedad',1
		END CATCH
	END
