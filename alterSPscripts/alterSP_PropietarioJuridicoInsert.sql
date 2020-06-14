USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioJuridicoInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioJuridicoInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioJuridicoInsert] 
    @Responsable varchar(100),
	@inTipDocIdRepresentante int,
	@inDocidRepresentante varchar(30),
	@inDocidPersonaJuridica varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			DECLARE @idPropietario INT
			SET @idPropietario = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inDocidPersonaJuridica AND [activo] = 1)
		END TRY
		BEGIN CATCH
			THROW 98264,'Error: No se ha podido encontrar ninguna propiedad para asociar el nuevo propietario juridico.',1;
		END CATCH
		BEGIN TRY
			INSERT INTO [dbo].[PropietarioJuridico] ([id], [Representante],[DocidRepresentante],[TipDocIdRepresentante],[docidPersonaJuridica])
			SELECT @idPropietario,@responsable,@inDocidRepresentante,@inTipDocIdRepresentante,@inDocidPersonaJuridica
			WHERE  @responsable != '-1' AND 
					@inDocidRepresentante != '-1' AND 
					@inTipDocIdRepresentante != -1 AND 
					@inDocidPersonaJuridica	!= '-1' 
		END TRY
		BEGIN CATCH
			THROW 72635,'Error: No se ha podido insertar el propietario juridico.',1;
		END CATCH
               
	COMMIT
