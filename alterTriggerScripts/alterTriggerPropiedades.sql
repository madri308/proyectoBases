--====================================
--  Create database trigger template 
--====================================
USE [Progra]
GO

IF EXISTS(
  SELECT *
    FROM sys.triggers
   WHERE name = '[dbo].[cambiosPropiedad]'
     AND parent_class_desc = N'[Progra]'
)
	DROP TRIGGER [dbo].[cambiosPropiedad] ON DATABASE
GO

CREATE TRIGGER [dbo].[cambiosPropiedad]
ON [dbo].[Propiedad]
AFTER  INSERT,UPDATE
AS
DECLARE @userid int
SET @userid = (SELECT [id] FROM [dbo].[Usuario] WHERE [nombre] = @inInsertedBy)
INSERT INTO [dbo].[BitacoraCambio] ([idEntityType], [entityID], [jsonAntes],[jsonDespues],[insertedAt],[insertedBy],[insertedIn])
SELECT @inIdEntityType, @inEntityID, @inJsonAntes,@inJsonDespues,getdate(),@userid,@inInsertedIn
		


