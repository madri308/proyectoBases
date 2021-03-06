GO
/****** Object:  StoredProcedure [dbo].[SP_ComprobantePagoDelete]    Script Date: 6/2/2020 4:51:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoDelete] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Usuario]
			SET    [activo] = 0
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 53789 , 'Error: No se ha podido eliminar el comprobante de pago' , 1;
		END CATCH
	COMMIT
