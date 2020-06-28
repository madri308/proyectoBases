﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioDelete] 
    @inIdentificacion varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS  	
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			BEGIN TRAN
				declare @jsonAntes varchar(500), @idModified int, @insertedAt DATE
				--GUARDA EL JSON DEL ROW DE PROPIETARIO ANTES
				SET @jsonAntes = (SELECT [id], [nombre], [valorDocId], [identificacion], [fechaDeIngreso]
				FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion
				FOR JSON PATH)
				--ELIMINA EL PROPIETARIO
				UPDATE [dbo].[Propietario]
				SET    [activo] = 0
				WHERE  [identificacion] = @inIdentificacion 
				--GUARDA EL ID y fecha
				SET @insertedAt = GETDATE()
				SET @idModified = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion)
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
													@inJsonDespues = NULL, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario, @inInsertedAt = @insertedAt
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 55004,'Error: No se ha podido eliminar el propietario',1;
		END CATCH	
	END
