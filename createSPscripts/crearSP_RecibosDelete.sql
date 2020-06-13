GO
/****** Object:  StoredProcedure [dbo].[SP_RecibosDelete]    Script Date: 6/2/2020 5:05:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_RecibosDelete] 
    @id int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Usuario]
	SET    [activo] = 0
	WHERE  [id] = @id

	COMMIT
