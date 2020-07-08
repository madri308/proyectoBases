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
	@inIdentificacionOriginal varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS 
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON  
			BEGIN TRAN
				declare @jsonAntes varchar(500),@jsonDespues varchar(500), @idModified int, @insertedAt DATE
				--GUARDA EL ID
				SET @insertedAt = GETDATE()
				SET @idModified = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacionOriginal)
				--GUARDA EL JSON DEL ROW DE PROPIETARIO ANTES
				SET @jsonAntes = (SELECT [id], [nombre], [valorDocId], [identificacion], [fechaDeIngreso]
				FROM [dbo].[Propietario] WHERE [id] = @idModified
				FOR JSON PATH)
				--ACTUALIZA EL PROPIETARIO
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
				--GUARDA EL JSON DEL ROW DE PROPIETARIO DESPUES
				SET @jsonDespues = (SELECT [id], [nombre], [valorDocId], [identificacion], [fechaDeIngreso]
				FROM [dbo].[Propietario] WHERE [id] = @idModified
				FOR JSON PATH)
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
													@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario, @inInsertedAt = @insertedAt
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 55001,'Error: No se ha podido modificar el propietario.',1;
		END CATCH
	END
