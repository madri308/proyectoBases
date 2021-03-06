GO
/****** Object:  StoredProcedure [dbo].[SP_PropietarioInsert]    Script Date: 6/2/2020 4:58:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioInsert] 
    @inNombre varchar(100),
    @inValorDocId int,
    @inIdentificacion varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	BEGIN TRY
		INSERT INTO [dbo].[Propietario] ([nombre], [valorDocId], [identificacion],[fechaDeIngreso])
		SELECT @inNombre, @inValorDocId, @inIdentificacion,CONVERT(VARCHAR(10), getdate(), 126)
    END TRY
	BEGIN CATCH
		THROW 98762, 'Error: No se ha podido insertar el propietario.',1;
	END CATCH;
	COMMIT
