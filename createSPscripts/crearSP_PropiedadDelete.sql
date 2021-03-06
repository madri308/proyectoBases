GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadDelete]    Script Date: 6/2/2020 4:55:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelete] 
    @inNumFinca varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Propiedad]
			SET    [activo] = 0
			WHERE  [numFinca] = @inNumFinca
		END TRY
		BEGIN CATCH
			THROW 69023,'Error: No se ha podido eliminar la propiedad.',1;
		END CATCH
	COMMIT
