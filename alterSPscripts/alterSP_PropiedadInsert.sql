﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropiedadInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropiedadInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropiedadInsert] 
    @inValor money,
    @inDireccion varchar(150),
    @inNumFinca varchar(30)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			INSERT INTO [dbo].[Propiedad] ([valor], [direccion], [numFinca],[fechaDeIngreso])
			SELECT @inValor, @inDireccion, @inNumFinca,CONVERT(VARCHAR(10), getdate(), 126)
			WHERE @inValor != -1 AND @inDireccion != '-1' AND @inNumFinca != '-1'
        END TRY
		BEGIN CATCH
			THROW 62435,'Error: No se ha podido insertar la propiedad.',1;
		END CATCH
	END
