GO
/****** Object:  StoredProcedure [dbo].[SP_PropietarioJuridicoDelete]    Script Date: 6/2/2020 4:59:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioJuridicoDelete] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY	
			UPDATE [dbo].[Propietario]
			SET    [activo] = 0
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 873364,'Error: No se ha podido eliminar el propietario juridico.',1;
		END CATCH
	COMMIT
