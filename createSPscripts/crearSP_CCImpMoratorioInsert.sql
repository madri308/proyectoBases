GO
/****** Object:  StoredProcedure [dbo].[SP_CCImpMoratorioInsert]    Script Date: 6/2/2020 4:48:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCImpMoratorioInsert] 
    @inId int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[CCImpMoratorio] ([id])
			SELECT @inId
		END TRY
		BEGIN CATCH
			THROW 6001,'Error: No se ha podido insertar concepto de cobro de tipo moratorio.',1;
		END CATCH	
	COMMIT
