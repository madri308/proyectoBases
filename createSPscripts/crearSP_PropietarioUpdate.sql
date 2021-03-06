GO
/****** Object:  StoredProcedure [dbo].[SP_PropietarioUpdate]    Script Date: 6/2/2020 5:05:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioUpdate] 
    @inNombre varchar(100),
    @inValorDocId int,
    @inIdentificacion varchar(30),
	@inIdentificacionOriginal varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		

	BEGIN TRY
			UPDATE [dbo].[Propietario]
				SET [nombre] = CASE @inNombre
					WHEN '-1' THEN [nombre]
					ELSE @inNombre
				END,
				[valorDocId]= CASE @inValorDocId
					WHEN '-1' THEN [valorDocId]
					ELSE @inValorDocId
				END,
				[identificacion] = CASE @inIdentificacion
					WHEN '-1' THEN [identificacion]
					ELSE @inIdentificacion
				END
			WHERE [identificacion] = @inIdentificacionOriginal
			END TRY
		BEGIN CATCH
			THROW 55001,'Error: No se ha podido modificar el propietario.',1;
		END CATCH
	COMMIT
