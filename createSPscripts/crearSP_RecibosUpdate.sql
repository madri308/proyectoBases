GO
/****** Object:  StoredProcedure [dbo].[SP_RecibosUpdate]    Script Date: 6/2/2020 5:06:43 PM ******/
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
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Recibos]
	SET    [id_CC] = @id_CC, [id_Comprobante] = @id_Comprobante, [monto] = @monto, [esPendiente] = @esPendiente
	WHERE  [id] = @id

	COMMIT
