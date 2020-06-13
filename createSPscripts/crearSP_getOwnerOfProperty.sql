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
CREATE PROCEDURE [dbo].[SP_getOwnerOfProperty] @inNumFinca varchar(100)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @idFinca INT
			SET @idFinca = ( SELECT [id]
								FROM [dbo].[Propiedad]
								WHERE [numFinca] = @inNumFinca)
		END TRY
		BEGIN CATCH
			THROW 55300, 'Error: No se ha podido encontrar propiedad con ese numero de finca',1 ;
		END CATCH
		BEGIN TRY
			SELECT [dbo].[Propietario].[nombre], [dbo].[Propietario].[identificacion], [dbo].[Propietario].[valorDocId] ,[dbo].[Propietario].[fechaDeIngreso]
			FROM [dbo].[Propietario] JOIN [dbo].[PropiedadDelPropietario] ON ([dbo].[Propietario].[id] = [dbo].[PropiedadDelPropietario].[id_Propietario])
			WHERE [dbo].[PropiedadDelPropietario].[id_Propiedad] = @idFinca AND [dbo].[Propietario].[activo] = 1
		END TRY
		BEGIN CATCH
			THROW 55400, 'Error: No se ha encontrado propietario de esa propiedad',1;
		END CATCH
	COMMIT
END
GO
