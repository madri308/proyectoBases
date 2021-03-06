﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadSelect] 
    @inNumFinca VARCHAR(30)
AS 
	BEGIN 
		BEGIN TRY	
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			SELECT	[valor], [direccion], [numFinca] 
			FROM   [dbo].[Propiedad] 
			WHERE  ([numFinca] = @inNumFinca OR @inNumFinca IS NULL OR @inNumFinca = '-1') AND [activo] = 1
		END TRY
		BEGIN CATCH
			THROW 79235,'Error: No se ha podido mostrar la propiedad.',1;
		END CATCH
	END
