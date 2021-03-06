﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioJuridicoSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioJuridicoSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioJuridicoSelect] 
    @docidPersonaJuridica varchar(30)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  

			SELECT [dbo].[Propietario].[nombre],[dbo].[Propietario].[identificacion],[dbo].[Propietario].[valorDocId],
					[dbo].[Propietario].[fechaDeIngreso],[dbo].[PropietarioJuridico].[DocidRepresentante],[dbo].[PropietarioJuridico].[Representante],
					[dbo].[PropietarioJuridico].[TipDocIdRepresentante]
			FROM [dbo].[Propietario] INNER JOIN  [dbo].[PropietarioJuridico]
			ON [dbo].[Propietario].[id] = [dbo].[PropietarioJuridico].[id]
			WHERE  ([dbo].[Propietario].[identificacion] = @docidPersonaJuridica OR @docidPersonaJuridica IS NULL) AND [dbo].[Propietario].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 92635,'Error: No se la podido mostrar propietarios juridicos.',1;
		END CATCH
	END
