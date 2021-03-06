GO
/****** Object:  StoredProcedure [dbo].[SP_PropietarioDelete]    Script Date: 6/2/2020 4:58:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioDelete] 
    @inIdentificacion varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Propietario]
			SET    [activo] = 0
			WHERE  [identificacion] = @inIdentificacion 
		END TRY
		BEGIN CATCH
			THROW 55004,'Error: No se ha podido eliminar el propietario',1;
		END CATCH	
	COMMIT
