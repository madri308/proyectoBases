GO
/****** Object:  StoredProcedure [dbo].[SP_ComprobantePagoSelect]    Script Date: 6/2/2020 4:52:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [id], [fecha], [total] 
			FROM   [dbo].[ComprobantePago] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 53901,'Error: No se ha podido mostrar comprobante de pago.',1;
		END CATCH
	COMMIT
