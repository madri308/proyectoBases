﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCDePropiedadInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCDePropiedadInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCDePropiedadInsert] 
    @inIdcobro int,
    @inNumFinca varchar(30)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			DECLARE @idPropiedad int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
			INSERT INTO [dbo].[CCDePropiedad] ([id_CC], [id_Propiedad], [fechaInicio])
			SELECT @inIdcobro,@idPropiedad,CONVERT(VARCHAR(10), getdate(), 126)
			WHERE NOT EXISTS(SELECT [id] FROM [dbo].[CCDePropiedad] WHERE [id_CC] = @inIdcobro AND [id_Propiedad] = @idPropiedad AND [activo] = 1)
		END TRY
		BEGIN CATCH
			THROW 67677,'Error: No se ha podido insertar la relacion entre la propiedad y el concepto de cobro',1;
		END CATCH
	END
