﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCFijoInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCFijoInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCFijoInsert] 
    @inId int,
    @inMonto money
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			INSERT INTO [dbo].[CCFijo] ([id], [Monto])
			SELECT @inId, @inMonto
			WHERE @inId > -1 AND @inMonto > -1
		END TRY
		BEGIN CATCH
			THROW 6000, 'Error: No se ha podido insertar concepto de cobro fijo.',1;
		END CATCH
	END
