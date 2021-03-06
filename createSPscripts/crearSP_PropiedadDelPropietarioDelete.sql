GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadDelPropietarioDelete]    Script Date: 6/2/2020 4:55:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioDelete] @inNumFinca varchar(30), @inIdentificacion varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		DECLARE @idPropiedad int, @idPropietario int
		BEGIN TRY
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca)
			SET @idPropietario = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion)
		END TRY
		BEGIN CATCH
			THROW 86786,'Error: No se ha podido encontrar propiedad o propietario con los datos especificados.',1;
		END CATCH
		BEGIN TRY
			UPDATE [dbo].[PropiedadDelPropietario]
			SET    [activo] = 0
			WHERE  [id_Propiedad] = @idPropiedad AND [id_Propietario] = @idPropietario
		END TRY
		BEGIN CATCH
			THROW 86784,'Error: No se ha podido eliminar la relacion entre la propiedad y el propietario.',1;
		END CATCH
	COMMIT
