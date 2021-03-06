GO
/****** Object:  StoredProcedure [dbo].[SP_getUsersOfProperty]    Script Date: 6/2/2020 4:33:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_getUsersOfProperty] @inNumFinca varchar(100)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @idFinca INT
			SET @idFinca = ( SELECT [id]
								FROM [dbo].[Propiedad]
								WHERE [numFinca] = @inNumFinca)
		END TRY
		BEGIN CATCH
			THROW 88000,'Error: No se ha encontrado ninguna propiead con el numero de finca.',1;
		END CATCH
		BEGIN TRY
			SELECT [dbo].[Usuario].[nombre],[dbo].[Usuario].[tipoDeUsuario],[dbo].[Usuario].[fechaDeIngreso]
			FROM [dbo].[Usuario] JOIN [dbo].[UsuarioDePropiedad] ON ([dbo].[Usuario].[id] = [dbo].[UsuarioDePropiedad].[id_Usuario])
			WHERE [dbo].[UsuarioDePropiedad].[id_Propiedad] = @idFinca AND [dbo].[Usuario].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 88100,'Error: No se ha podido encontrar ningun usuario de la propiedad.',1;
		END CATCH
	COMMIT
END
