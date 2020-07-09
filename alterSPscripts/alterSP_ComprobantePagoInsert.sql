USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ComprobantePagoInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ComprobantePagoInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ComprobantePagoInsert] @inTotal money, @inFecha Date
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			INSERT INTO [dbo].[ComprobantePago] ([fecha], [total])
			SELECT @inFecha , @inTotal
        END TRY
		BEGIN CATCH
			THROW 75689,'Error: No se ha podido insertar el comprobante de pago.',1;
		END CATCH
	END

