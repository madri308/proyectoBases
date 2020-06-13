GO
/****** Object:  StoredProcedure [dbo].[SP_RecibosInsert]    Script Date: 6/2/2020 5:06:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_RecibosInsert] 
    @id int,
    @id_CC int,
    @id_Comprobante int,
    @monto money,
    @esPendiente bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Recibos] ([id], [id_CC], [id_Comprobante], [monto], [esPendiente])
	SELECT @id, @id_CC, @id_Comprobante, @monto, @esPendiente

	COMMIT
