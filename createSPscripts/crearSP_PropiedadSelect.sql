GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadSelect]    Script Date: 6/2/2020 4:57:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadSelect] 
    @inNumFinca VARCHAR(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT	[valor], [direccion], [numFinca] 
			FROM   [dbo].[Propiedad] 
			WHERE  ([numFinca] = @inNumFinca OR @inNumFinca IS NULL) AND [activo] = 1
		END TRY
		BEGIN CATCH
			THROW 79235,'Error: No se ha podido mostrar la propiedad.',1;
		END CATCH
	COMMIT
