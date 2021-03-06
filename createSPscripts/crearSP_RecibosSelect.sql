GO
/****** Object:  StoredProcedure [dbo].[SP_RecibosSelect]    Script Date: 6/2/2020 5:06:21 PM ******/
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
