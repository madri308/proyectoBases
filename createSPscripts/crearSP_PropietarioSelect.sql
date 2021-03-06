GO
/****** Object:  StoredProcedure [dbo].[SP_PropietarioSelect]    Script Date: 6/2/2020 5:04:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioSelect] 
    @inIdentificacion varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
		BEGIN TRY
			SELECT [nombre], [valorDocId], [identificacion],[fechaDeIngreso]
			FROM   [dbo].[Propietario] 
			WHERE  ([identificacion] = @inIdentificacion OR @inIdentificacion IS NULL) AND [activo]  = 1
		END TRY
		BEGIN CATCH
			THROW 55002,'Error: No se han podido mostrar los propietarios',1;
		END CATCH
	COMMIT
