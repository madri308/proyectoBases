﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDelete] 
    @inUsuario varchar(30),@inUsuarioACargo varchar(20), @inIPusuario varchar(20), @insertedAt DATE
AS 
	BEGIN 
		BEGIN TRY 
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			BEGIN TRAN
				declare @jsonAntes varchar(500), @idModified int
				----GUARDA EL JSON DEL ROW DE USUARIO ANTES
				SET @jsonAntes = (SELECT [id], [nombre], [password], [tipoDeUsuario], [fechaDeIngreso]
				FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario
				FOR JSON PATH)
				--ELIMINA EL USUARIO
				UPDATE [dbo].[Usuario]
				SET    [activo] = 0
				WHERE  [nombre] = @inUsuario
				--GUARDA EL ID Y FECHA
				SET @insertedAt = GETDATE()
				SET @idModified = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario)
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
													@inJsonDespues = NULL, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario, @inInsertedAt = @insertedAt
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 92039, 'Error: no se ha podido eliminar el usuario.',1
		END CATCH;
	END
