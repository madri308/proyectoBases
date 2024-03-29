GO
/****** Object:  StoredProcedure [dbo].[SP_CCFijoInsert]    Script Date: 6/2/2020 4:46:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCFijoInsert] 
    @inId int,
    @inMonto money
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[CCFijo] ([id], [Monto])
			SELECT @inId, @inMonto
		END TRY
		BEGIN CATCH
			THROW 6000, 'Error: No se ha podido insertar concepto de cobro fijo.',1;
		END CATCH
	COMMIT
