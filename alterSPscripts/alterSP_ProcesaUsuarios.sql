USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcesaUsuarios]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcesaUsuarios]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcesaUsuarios] @Usuario UsuarioTipo READONLY
AS  
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON 
			declare @jsonDespues varchar(500), @idMenor int, @idMayor int, @idModified int
			BEGIN TRAN
				SELECT @idMenor = min([id]), @idMayor=max([id]) FROM @Usuario
				WHILE @idMenor<=@idMayor
				BEGIN
					INSERT INTO [dbo].[Usuario] ([nombre], [password], [tipoDeUsuario],[fechaDeIngreso])
					SELECT nombre,contrasenna,tipoDeUsuario,Fecha
					FROM @Usuario 
					WHERE id = @idMenor

					SET @idModified = (SELECT id FROM [dbo].[Usuario] WHERE nombre IN (SELECT nombre FROM @Usuario WHERE id = @idMenor))
					SET @jsonDespues = (SELECT [id],[nombre],[password],[tipoDeUsuario],[fechaDeIngreso]
									FROM [dbo].[Usuario] WHERE [activo] = 1 AND [id] = @idModified
									FOR JSON PATH)

					EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 3,@inEntityID = @idModified, @inJsonAntes = NULL,
																	@inJsonDespues = @jsonDespues, @inInsertedBy = 'usuario1', 
																	@inInsertedIn = 123
					SET @idMenor = @idMenor+1 
				END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 982734,'Error: No se han podido procesar los usuarios.',1;
		END CATCH
	END
