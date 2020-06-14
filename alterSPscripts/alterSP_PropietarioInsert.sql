USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioInsert]  
END 
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
		WHERE @inNombre != '-1' AND 
				@inValorDocId != -1 AND 
				@inIdentificacion != '-1'
     END TRY
	BEGIN CATCH
		THROW 98762, 'Error: No se ha podido insertar el propietario.',1;
	END CATCH;
	COMMIT
