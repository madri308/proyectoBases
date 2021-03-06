GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadDelPropietarioUpdate]    Script Date: 6/2/2020 4:56:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioUpdate] 
    @id int,
    @inIdentificacion varchar(30),
    @inId_Propiedad varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[PropiedadDelPropietario]
			SET    [id_Propietario] = @inIdentificacion, [id_Propiedad] = @inId_Propiedad
			WHERE  [id] = @id

			UPDATE	[dbo].[PropiedadDelPropietario]
			SET [id_Propietario] = (SELECT id FROM Propietario
									WHERE @inIdentificacion = Propietario.identificacion)
		END TRY
		BEGIN CATCH
			THROW 73256,'Error: No se ha podido modificar la relacion entre la propiedad y el propietario.',1;
		END CATCH
	COMMIT
