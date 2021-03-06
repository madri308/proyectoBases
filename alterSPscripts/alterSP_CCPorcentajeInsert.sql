﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCPorcentajeInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCPorcentajeInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCPorcentajeInsert] 
    @inId int,
    @inValorPorcentual int
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			INSERT INTO [dbo].[CCPorcentaje] ([id], [valorPorcentual])
			SELECT @inId, @inValorPorcentual
			WHERE @inValorPorcentual != '-1' AND @inId != '-1'
        END TRY
		BEGIN CATCH
			THROW 66002 ,'Error: No se ha podido crear concepto de cobro tipo porcentual.',1;
		END CATCH
	END
