USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_CCDePropiedadDelete]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_CCDePropiedadDelete]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_CCDePropiedadDelete] 
    @inNumFinca varchar(30), @inIdCC int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			DECLARE @idPropiedad int
			SET @idPropiedad = (SELECT [id] FROM [dbo].[Propiedad] WHERE [numFinca] = @inNumFinca AND [activo] = 1)
		END TRY
		BEGIN CATCH
			THROW 67082,'Error: No se ha encontrado ninguna propiedad con ese numero de finca.',1;
		END CATCH
		BEGIN TRY
			UPDATE [dbo].[CCDePropiedad]
			SET    [activo] = 0
			WHERE  [id_CC] = @inIdCC AND [id_Propiedad] = @idPropiedad
		END TRY
		BEGIN CATCH
			THROW 67080,'Error: No se ha podido eliminar la relacion entre el concepto de cobro y la propiedad.',1;
		END CATCH
	COMMIT
