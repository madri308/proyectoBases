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
	@inNombreOriginal varchar(100)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
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
		END TRY
		BEGIN CATCH
			THROW 55501,'Error al modificar usuario, por favor verifique los datos',1;
		END CATCH
	END
