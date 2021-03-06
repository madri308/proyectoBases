GO
/****** Object:  StoredProcedure [dbo].[SP_CCDePropiedadSelect]    Script Date: 6/2/2020 4:37:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCDePropiedadSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [id], [id_CC], [id_Propiedad], [fechaInicio] 
			FROM   [dbo].[CCDePropiedad] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 56667,'Error: No se ha podido mostrar la relacion entre concepto cobro y propiedad',1;
		END CATCH
	COMMIT
