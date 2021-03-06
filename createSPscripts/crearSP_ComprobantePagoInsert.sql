GO
/****** Object:  StoredProcedure [dbo].[SP_ComprobantePagoInsert]    Script Date: 6/2/2020 4:51:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoInsert] @inTotal money
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[ComprobantePago] ([fecha], [total])
			SELECT CONVERT(VARCHAR(10), getdate(), 126), @inTotal
        END TRY
		BEGIN CATCH
			THROW 75689,'Error: No se ha podido insertar el comprobante de pago.',1;
		END CATCH
	COMMIT
