﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioJuridicoUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioJuridicoUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioJuridicoUpdate] 
    @inResponsable varchar(100),
	@inDocIdRespresentante VARCHAR (30),
	@inTipoDocIdRepresentante int,
	@inDocidPersonaJuridica varchar(30),
	@inDocidPersonaJuridicaOriginal varchar(30)
AS   
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			UPDATE [dbo].[PropietarioJuridico]
				SET [Representante] = CASE @inResponsable
					WHEN '-1' THEN [Representante]
					ELSE @inResponsable
				END,
				[DocidRepresentante]= CASE @inDocIdRespresentante
					WHEN '-1' THEN [DocidRepresentante]
					ELSE @inDocIdRespresentante
				END,
				[TipDocIdRepresentante] = CASE @inTipoDocIdRepresentante
					WHEN -1 THEN [TipDocIdRepresentante]
					ELSE @inTipoDocIdRepresentante
				END
				WHERE [docidPersonaJuridica] = @inDocidPersonaJuridicaOriginal AND EXISTS
						(SELECT [activo] FROM [dbo].[Propietario] WHERE [identificacion] = @inDocidPersonaJuridicaOriginal)
		END TRY
		BEGIN CATCH
			THROW 73846,'Error: No se ha podido modificar el propietario juridico.',1;
		END CATCH
	END
