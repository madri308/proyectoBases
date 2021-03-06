GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadDelPropietarioSelect]    Script Date: 6/2/2020 4:56:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadDelPropietarioSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	BEGIN TRY
		SELECT [id], [id_Propietario], [id_Propiedad] 
		FROM   [dbo].[PropiedadDelPropietario] 
		WHERE  ([id] = @inId OR @inId IS NULL) 
	END TRY
	BEGIN CATCH
		THROW 95678,'Error: No se ha podido mostrar la relacion entre el propietario y la propiedad.',1;
	END CATCH
	COMMIT
