USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcActualizarValProp]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcActualizarValProp]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcActualizarValProp] @nuevosValProp ValorPropiedadTipo READONLY
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			UPDATE [dbo].[Propiedad]
			SET valor = NVP.nuevoValor
			FROM [dbo].[Propiedad]
			INNER JOIN @nuevosValProp NVP ON Propiedad.numFinca = NVP.numFinca 
		END TRY
		BEGIN CATCH
			THROW 6000, 'Error: No se ha podido crear el pago.',1;
		END CATCH
	END
