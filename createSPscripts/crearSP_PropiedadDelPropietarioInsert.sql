GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadDelPropietarioInsert]    Script Date: 6/2/2020 4:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioInsert] @inNumFinca varchar(30), @inIdentificacion varchar(30)
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
			INSERT INTO [dbo].[PropiedadDelPropietario] ([id_Propietario], [id_Propiedad])
			SELECT @idPropiedad, @idPropietario
		END TRY
		BEGIN CATCH
			THROW 73654,'Error: No se ha podido insertar una relacion entre el propietario y la propiedad',1;
		END CATCH
	COMMIT

