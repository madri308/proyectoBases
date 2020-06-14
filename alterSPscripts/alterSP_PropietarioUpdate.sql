USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioUpdate]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioUpdate]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioUpdate] 
    @inNombre varchar(30),
    @inValorDocId int,
    @inIdentificacion varchar(30),
	@inIdentificacionOriginal varchar(30)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			UPDATE [dbo].[Propietario]
				SET [nombre] = CASE @inNombre
					WHEN '-1' THEN [nombre]
					ELSE @inNombre
				END,
				[valorDocId]= CASE @inValorDocId
					WHEN -1 THEN [valorDocId]
					ELSE @inValorDocId
				END,
				[identificacion] = CASE @inIdentificacion
					WHEN '-1' THEN [identificacion]
					ELSE @inIdentificacion
				END
			WHERE [identificacion] = @inIdentificacionOriginal AND [activo] = 1
		END TRY
		BEGIN CATCH
			THROW 55001,'Error: No se ha podido modificar el propietario.',1;
		END CATCH
	END
