USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_BitacoraCambioInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_BitacoraCambioInsert] 
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType int,@inEntityID int,@inJsonAntes VARCHAR(500),@inJsonDespues VARCHAR(500),
											@inInsertedBy varchar(20), @inInsertedIn varchar(20), @inInsertedAt DATE
AS   
	BEGIN 
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @userid int
			SET @userid = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inInsertedBy)
			INSERT INTO [dbo].[BitacoraCambio] ([idEntityType], [entityID], [jsonAntes],[jsonDespues],[insertedAt],[insertedBy],[insertedIn])
			SELECT @inIdEntityType, @inEntityID, @inJsonAntes,@inJsonDespues,@inInsertedAt,@userid,@inInsertedIn
		END TRY
		BEGIN CATCH
			THROW 762839,'Error: No se ha podido guardar el cambio en la bitacora',1;
		END CATCH
	END
