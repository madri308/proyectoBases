GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioUpdate]    Script Date: 6/2/2020 5:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioUpdate] 
    @inNombre varchar(100),
    @inPassword varchar(30),
    @inTipoDeUsuario bit,
	@inNombreOriginal varchar(100)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

		BEGIN TRY
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
			WHERE [nombre] = @inNombreOriginal
		END TRY
		BEGIN CATCH
			THROW 55501,'Error al modificar usuario, por favor verifique los datos',1;
		END CATCH

	COMMIT
