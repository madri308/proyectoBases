﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCDePropiedadUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCDePropiedadUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCDePropiedadUpdate] 
    @inIdCCOrigianl int,
    @inId_CC int,
    @inNumFincaOriginal varchar(30),
	@inNumFinca varchar(30)

AS   
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @idPropiedad int, @idPropiedadOriginal int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			SET @idPropiedadOriginal =  (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFincaOriginal AND [activo] = 1)
		
			UPDATE [dbo].[CCDePropiedad]
				SET [id_CC] = CASE @inId_CC
						WHEN '-1' THEN [id_CC]
						ELSE @inId_CC
					END,
					[id_Propiedad] = isNull(@idPropiedad,[id_Propiedad])
				WHERE [id_CC] = @inIdCCOrigianl AND [id_Propiedad] = @idPropiedadOriginal AND [activo] = 1
		END TRY
		BEGIN CATCH
			THROW 876214 , 'Error: No se ha podido actualizar la relacion.',1;
		END CATCH
		
	END