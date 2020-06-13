-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_getPropertyOfOwner] @inNombre varchar(100), @inIdentificacion varchar(30)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @idPropietario INT
			SET @idPropietario = (	SELECT [id] 
									FROM [dbo].[Propietario] 
									WHERE [nombre] = @inNombre OR [identificacion] = @inIdentificacion) 
		END TRY
		BEGIN CATCH
			THROW 55100, 'Error: No se ha encontrado propietario con ese nombre o identificacion.',1;
		END CATCH
		BEGIN TRY	
			SELECT [dbo].[Propiedad].[id], [dbo].[Propiedad].[numFinca], [dbo].[Propiedad].[valor], [dbo].[Propiedad].[direccion] 
			FROM [dbo].[Propiedad] JOIN [dbo].[PropiedadDelPropietario] ON ([dbo].[Propiedad].[id] = [dbo].[PropiedadDelPropietario].[id])
			WHERE [dbo].[PropiedadDelPropietario].[id_Propietario] = @idPropietario
		END TRY
		BEGIN CATCH
			THROW 55200, 'Error: No se ha podido encontrar propiedad del propietario',1;
		END CATCH
	COMMIT
END
GO
