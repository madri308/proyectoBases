﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCImpMoratorioInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCImpMoratorioInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCImpMoratorioInsert] 
    @inId int
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
	
			INSERT INTO [dbo].[CCImpMoratorio] ([id])
			SELECT @inId
			WHERE @inId != -1
		END TRY
		BEGIN CATCH
			THROW 6001,'Error: No se ha podido insertar concepto de cobro de tipo moratorio.',1;
		END CATCH	
	END
