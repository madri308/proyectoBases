﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioJuridicoDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioJuridicoDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioJuridicoDelete] 
    @docidPersonaJuridica VARCHAR(30)
AS 
	BEGIN
		BEGIN TRY		
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			UPDATE [dbo].[Propietario]
			SET    [activo] = 0
			WHERE  [identificacion] = @docidPersonaJuridica
		END TRY
		BEGIN CATCH
			THROW 873364,'Error: No se ha podido eliminar el propietario juridico.',1;
		END CATCH
	END
