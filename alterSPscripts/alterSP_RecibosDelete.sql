USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_RecibosDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_RecibosDelete]  
END 
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
