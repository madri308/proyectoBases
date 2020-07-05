﻿USE [Progra]
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
    @inNumFinca varchar(100)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @idPropiedad INT
			SET @idPropiedad = (select id from Propiedad where Propiedad.numFinca = @inNumFinca)


			SELECT [id_CC], [monto], [estado], [fecha], [fechaVence]
			FROM   [dbo].[Recibos] 
			WHERE  ([id_Propiedad] = @idPropiedad) 
		END TRY
		BEGIN CATCH
			THROW 63857,'Error: No se ha podido mostrar los recibos.',1;
		END CATCH
	END
