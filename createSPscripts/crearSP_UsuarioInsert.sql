GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioInsert]    Script Date: 6/2/2020 5:09:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioInsert] 
    @inNombre VARCHAR(100),
    @inPassword VARCHAR(30),
    @inTipoDeUsuario BIT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[Usuario] ([nombre], [password], [tipoDeUsuario],[fechaDeIngreso])
			SELECT @inNombre, @inPassword, @inTipoDeUsuario,CONVERT(VARCHAR(10), getdate(), 126)
		END TRY
		BEGIN CATCH
			THROW 762839,'Error: No se ha podido insertar el usuario, por favor revise los datos',1;
		END CATCH
	COMMIT
