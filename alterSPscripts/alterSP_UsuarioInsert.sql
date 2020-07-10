USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_UsuarioInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_UsuarioInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioInsert] @inNombre VARCHAR(100),@inPassword VARCHAR(30),@inTipoDeUsuario VARCHAR(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS   
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
		DECLARE @jsonDespues VARCHAR(500), @idModified INT, @insertedBy DATE
			BEGIN TRAN

				--INSERTA AL USUARIO
				INSERT INTO [dbo].[Usuario] ([nombre], [password], [tipoDeUsuario],[fechaDeIngreso])
				SELECT @inNombre, @inPassword, @inTipoDeUsuario,CONVERT(VARCHAR(10), getdate(), 126)
				WHERE (@inNombre != '-1' ) AND 
						(@inPassword != '-1') AND 
						(@inTipoDeUsuario != '-1' )
				--GUARDA EL ID y fecha
				SET @idModified = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inNombre)
				SET @insertedBy = GETDATE()
				--GUARDA EL JSON DEL ROW DE USUARIO
				SET @jsonDespues = (SELECT [id], [nombre], [password], [tipoDeUsuario], [fechaDeIngreso]
									FROM [dbo].[Usuario] WHERE [id] = @idModified
									FOR JSON PATH)
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 3,@inEntityID = @idModified, @inJsonAntes = NULL,
													@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario, @inInsertedAt = @insertedBy
			COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 762839,'Error: No se ha podido insertar el usuario, por favor revise los datos',1;
		END CATCH
	END
