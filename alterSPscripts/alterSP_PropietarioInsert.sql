USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_PropietarioInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_PropietarioInsert]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioInsert] 
    @inNombre varchar(100),
    @inValorDocId int,
    @inIdentificacion varchar(30), @inUsuarioACargo varchar(20), @inIPusuario varchar(20)
AS 
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			BEGIN TRAN	
				declare @jsonDespues varchar(500), @idModified int
				--INSERTA AL PROPIETARIO
				INSERT INTO [dbo].[Propietario] ([nombre], [valorDocId], [identificacion],[fechaDeIngreso])
				SELECT @inNombre, @inValorDocId, @inIdentificacion,CONVERT(VARCHAR(10), getdate(), 126)
				WHERE @inNombre != '-1' AND 
						@inValorDocId != -1 AND 
						@inIdentificacion != '-1'
				--GUARDA EL JSON DEL ROW DE USUARIO
				SET @jsonDespues = (SELECT [id], [nombre], [valorDocId], [identificacion], [fechaDeIngreso]
				FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion
				FOR JSON PATH)
				--GUARDA EL ID
				SET @idModified = (SELECT [id] FROM [dbo].[Propietario] WHERE [identificacion] = @inIdentificacion)
				--INSERTA EL CAMBIO
				EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = NULL,
													@inJsonDespues = @jsonDespues, @inInsertedBy = @inUsuarioACargo, 
													@inInsertedIn = @inIPusuario
			COMMIT
		 END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 98762, 'Error: No se ha podido insertar el propietario.',1;
		END CATCH;
	END
