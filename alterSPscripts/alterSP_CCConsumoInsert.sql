USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCConsumoInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCConsumoInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCConsumoInsert] 
    @inId int,
    @inValorPorM3 money
AS 
	BEGIN	
	 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			INSERT INTO [dbo].[CCConsumo] ([id], [valorPorM3])
			SELECT @inId, @inValorPorM3
			WHERE @inValorPorM3 > -1 AND @inId > -1
        END TRY
		BEGIN CATCH
			THROW 100000,'Error: No se ha podido insertar el concepto de cobro de tipo consumo.',1;
		END CATCH
	END
