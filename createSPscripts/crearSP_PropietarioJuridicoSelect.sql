GO
/****** Object:  StoredProcedure [dbo].[SP_PropietarioJuridicoSelect]    Script Date: 6/2/2020 4:59:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioJuridicoSelect] 
    @id int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [dbo].[Propietario].[nombre],[dbo].[Propietario].[identificacion],[dbo].[Propietario].[valorDocId],
					[dbo].[Propietario].[fechaDeIngreso],[dbo].[PropietarioJuridico].[DocidRepresentante],[dbo].[PropietarioJuridico].[Representante],
					[dbo].[PropietarioJuridico].[TipDocIdRepresentante]
			FROM [dbo].[Propietario] INNER JOIN  [dbo].[PropietarioJuridico]
			ON [dbo].[Propietario].[id] = [dbo].[PropietarioJuridico].[id]
			WHERE  ([dbo].[Propietario].[id] = @id OR @id IS NULL)
		END TRY
		BEGIN CATCH
			THROW 92635,'Error: No se la podido mostrar propietarios juridicos.',1;
		END CATCH
	COMMIT
