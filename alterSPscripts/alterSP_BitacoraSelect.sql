USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_BitacoraSelect]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_BitacoraSelect]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_BitacoraSelect] @inFechaDesde VARCHAR(30), @inFechaHasta VARCHAR(30), @inIdEntidad INT 
AS   
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @fechaDesde DATE , @fechaHasta DATE
			SET @fechaDesde = CONVERT(DATE,@inFechaDesde,121)
			SET @fechaHasta = CONVERT(DATE,@inFechaHasta,121)
			SELECT * FROM [dbo].[BitacoraCambio] 
			WHERE (insertedAt BETWEEN @fechaDesde AND @fechaHasta) 
				AND (idEntityType = @inIdEntidad)
		END TRY
		BEGIN CATCH
			THROW 60500, 'Error: No se ha podido mostrar los datos de la bitacora.',1;
		END CATCH
	END
