GO
/****** Object:  StoredProcedure [dbo].[SP_CCDePropiedadUpdate]    Script Date: 6/2/2020 4:38:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCDePropiedadUpdate] 
    @inId int,
    @inId_CC int,
    @inId_Propiedad int,
    @inFechaInicio date
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[CCDePropiedad]
			SET    [id_CC] = @inId_CC, [id_Propiedad] = @inId_Propiedad, [fechaInicio] = @inFechaInicio
			WHERE  [id] = @inId
		END TRY
	BEGIN CATCH
		THROW 87654 , 'Error: No se ha podido modificar la relacion entre concepto cobro y propiedad',1;
	END CATCH
	COMMIT
