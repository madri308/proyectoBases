GO
/****** Object:  StoredProcedure [dbo].[SP_PropiedadUpdate]    Script Date: 6/2/2020 4:57:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadUpdate] 
    @inValor money,
    @inDireccion varchar(150),
    @inNumFinca varchar(30),
	@inNumFincaOriginal varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Propiedad]
				SET [valor] = CASE @inValor
					WHEN '-1' THEN [valor]
					ELSE @inValor
				END,
				[direccion]= CASE @inDireccion
					WHEN '-1' THEN [direccion]
					ELSE @inDireccion
				END,
				[numFinca] = CASE @inNumFinca
					WHEN '-1' THEN [numFinca]
					ELSE @inNumFinca
				END
			WHERE [numFinca] = @inNumFincaOriginal
			END TRY
		BEGIN CATCH
			THROW 73652,'Error: No se ha podido modificar la propiedad.',1;
		END CATCH

	COMMIT
