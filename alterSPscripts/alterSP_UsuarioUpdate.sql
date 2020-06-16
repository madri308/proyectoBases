USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioUpdate] 
    @inNombre varchar(100),
    @inPassword varchar(30),
    @inTipoDeUsuario varchar(30),
	@inNombreOriginal varchar(100),
	@inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			BEGIN TRAN
				declare @jsonAntes varchar(500), @jsonDespues varchar(500), @idModified int
				----GUARDA EL JSON DEL ROW DE USUARIO ANTES
				SET @jsonAntes = (SELECT [id], [nombre], [password], [tipoDeUsuario], [fechaDeIngreso]
				FROM [dbo].[Usuario] WHERE [nombre] = @inNombreOriginal
				FOR JSON PATH)
				--ACTUALIZA AL USUARIO
				UPDATE [dbo].[Usuario]
					SET [nombre] = CASE @inNombre
						WHEN '-1' THEN [nombre]
						ELSE @inNombre
					END,
					[password]= CASE @inPassword
						WHEN '-1' THEN [password]
						ELSE @inPassword
					END,
					[tipoDeUsuario] = CASE @inTipoDeUsuario
						WHEN '-1' THEN [tipoDeUsuario]
						ELSE @inTipoDeUsuario
					END
					WHERE [nombre] = @inNombreOriginal AND [activo] = 1
				--GUARDA EL JSON DEL ROW DE USUARIO DESPUES
				SET @jsonDespues = (SELECT [id], [nombre], [password], [tipoDeUsuario], [fechaDeIngreso]
				FROM [dbo].[Usuario] WHERE [nombre] = @inNombreOriginal
				FOR JSON PATH)
				--GUARDA EL ID
				SET @idModified = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inNombreOriginal)
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
													@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 55501,'Error al modificar usuario, por favor verifique los datos',1;
		END CATCH
	END
