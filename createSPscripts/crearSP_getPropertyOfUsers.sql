GO
/****** Object:  StoredProcedure [dbo].[SP_getPropertyOfUsers]    Script Date: 6/2/2020 4:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_getPropertyOfUsers] @inUsuario varchar(100)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @idUsuario INT
			SET @idUsuario = (	SELECT [id] 
									FROM [dbo].[Usuario] 
									WHERE [nombre] = @inUsuario) 
		END TRY
		BEGIN CATCH
			THROW 77000,'Error: No se encontro ningun usuario con ese nombre de usuario.',1;
		END CATCH
		BEGIN TRY
			SELECT [dbo].[Propiedad].[numFinca], [dbo].[Propiedad].[valor], [dbo].[Propiedad].[direccion]
			FROM [dbo].[Propiedad] JOIN [dbo].[UsuarioDePropiedad] ON ([dbo].[Propiedad].[id] = [dbo].[UsuarioDePropiedad].[id_Propiedad])
			WHERE [dbo].[UsuarioDePropiedad].[id_Usuario] = @idUsuario
		END TRY
		BEGIN CATCH
			THROW 77100,'Error: No se ha podido encontrar ninguna propiedad de el usuario.',1;
		END CATCH
	COMMIT
END
