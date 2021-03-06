﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioSelect] 
    @inIdentificacion varchar(30)
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			SELECT [nombre], [valorDocId], [identificacion],[fechaDeIngreso]
			FROM   [dbo].[Propietario] 
			WHERE  ([identificacion] = @inIdentificacion OR 
					@inIdentificacion IS NULL OR
					@inIdentificacion = '-1') AND [activo]  = 1
		END TRY
		BEGIN CATCH
			THROW 55002,'Error: No se han podido mostrar los propietarios',1;
		END CATCH
	END
