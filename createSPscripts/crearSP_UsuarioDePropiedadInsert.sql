GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioDePropiedadInsert]    Script Date: 6/2/2020 5:07:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDePropiedadInsert] @inUsuario int,@inNumFinca int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	BEGIN TRAN
		DECLARE @idUsuario int, @idPropiedad int
		BEGIN TRY
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca)
			SET @idUsuario = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inUsuario)
		END TRY
		BEGIN CATCH
			THROW 83925,'Error: No se ha encontrado propiedad o usuario, por favor verifique los datos.',1;
		END CATCH
         BEGIN TRY
			INSERT INTO [dbo].[UsuarioDePropiedad] ([id_Propiedad], [id_Usuario])
			SELECT @idPropiedad, @idUsuario
		END TRY
		BEGIN CATCH
			THROW 83645,'Error: No se ha podido insertar la relacion entre el usuario y la propiedad.',1;
		END CATCH      
	COMMIT
