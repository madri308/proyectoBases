GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadInsert]    Script Date: 6/2/2020 4:57:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadInsert] 
    @inValor money,
    @inDireccion varchar(150),
    @inNumFinca varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[Propiedad] ([valor], [direccion], [numFinca],[fechaDeIngreso])
			SELECT @inValor, @inDireccion, @inNumFinca,CONVERT(VARCHAR(10), getdate(), 126)
        END TRY
		BEGIN CATCH
			THROW 62435,'Error: No se ha podido insertar la propiedad.',1;
		END CATCH
	COMMIT
