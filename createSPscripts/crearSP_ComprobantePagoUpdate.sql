GO
/****** Object:  StoredProcedure [dbo].[SP_ComprobantePagoUpdate]    Script Date: 6/2/2020 4:52:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoUpdate] 
    @inId int,
    @inFecha date,
    @inTotal money
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[ComprobantePago]
			SET    [fecha] = @inFecha, [total] = @inTotal
			WHERE  [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 72456,'Error: No se ha podido modificar el comprobante de pago',1;
		END CATCH
	COMMIT
