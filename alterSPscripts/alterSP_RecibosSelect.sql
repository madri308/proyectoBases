USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_RecibosSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_RecibosSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_RecibosSelect] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [id], [id_CC], [id_Comprobante], [monto], [esPendiente] 
			FROM   [dbo].[Recibos] 
			WHERE  ([id] = @inId OR @inId IS NULL) 
		END TRY
		BEGIN CATCH
			THROW 63857,'Error: No se ha podido mostrar los recibos.',1;
		END CATCH
	COMMIT
