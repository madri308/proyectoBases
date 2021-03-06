GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioDePropiedadDelete]    Script Date: 6/2/2020 5:07:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDePropiedadDelete] 
    @inUsuario varchar(30), @inNumFinca varchar(30)
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
		THROW 83945,'Error: No se ha encontrado propiedad o usuario, por favor verifique los datos.',1;
	END CATCH
	BEGIN TRY
		UPDATE [dbo].[UsuarioDePropiedad]
		SET    [activo] = 0
		WHERE  [id_Usuario] = @idUsuario AND [id_Propiedad] = @idPropiedad
	END TRY
	BEGIN CATCH
		THROW 92836,'Error: No se ha podido eliminar la relacion entre el usuario y la propiedad.',1;
	END CATCH
	COMMIT
