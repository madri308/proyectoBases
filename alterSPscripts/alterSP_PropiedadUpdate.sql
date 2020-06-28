USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadUpdate]  
END 
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
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			UPDATE [dbo].[Propiedad]
				SET [valor] = CASE @inValor
					WHEN -1 THEN [valor]
					ELSE @inValor
				END,
				[direccion]= CASE @inDireccion
					WHEN '-1' THEN [direccion]
					ELSE @inDireccion
				END,
				[numFinca] = CASE @inNumFinca
					WHEN '-1' THEN [numFinca]
					ELSE @inNumFinca
				END,
				[fechaDeIngreso] = GETDATE()
			WHERE [numFinca] = @inNumFincaOriginal AND [activo] = 1
		END TRY
		BEGIN CATCH
			THROW 73652,'Error: No se ha podido modificar la propiedad.',1;
		END CATCH
	END
