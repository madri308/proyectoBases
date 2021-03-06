﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_RecibosUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_RecibosUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_RecibosUpdate] 
    @id int,
    @id_CC int,
    @id_Comprobante int,
    @monto money,
    @esPendiente bit
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			UPDATE [dbo].[Recibos]
			SET    [id_CC] = @id_CC, [id_Comprobante] = @id_Comprobante, [monto] = @monto, [esPendiente] = @esPendiente
			WHERE  [id] = @id
		END TRY
		BEGIN CATCH
			THROW 834628,'Error: No se ha podido actualizar el recibo.',1;
		END CATCH
	END
