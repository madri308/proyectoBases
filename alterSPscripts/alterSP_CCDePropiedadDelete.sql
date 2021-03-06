﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCDePropiedadDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCDePropiedadDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCDePropiedadDelete] 
    @inNumFinca varchar(30), @inIdCC int
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			DECLARE @idPropiedad int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
		
			UPDATE [dbo].[CCDePropiedad]
			SET    [activo] = 0
			WHERE  [id_CC] = @inIdCC AND [id_Propiedad] = @idPropiedad
		END TRY
		BEGIN CATCH
			THROW 67080,'Error: No se ha podido eliminar la relacion entre el concepto de cobro y la propiedad.',1;
		END CATCH
	END
