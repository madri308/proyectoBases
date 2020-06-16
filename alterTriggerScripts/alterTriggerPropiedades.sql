--====================================
--  Create database trigger template 
--====================================
USE [Progra]
GO

IF OBJECT_ID('[dbo].[cambiosPropiedad]') IS NOT NULL
BEGIN 
    DROP TRIGGER [dbo].[cambiosPropiedad]  
END 
GO
CREATE TRIGGER [dbo].[cambiosPropiedad]
ON [dbo].[Propiedad]
AFTER  INSERT,UPDATE
AS				
	declare @jsonAntes varchar(500), @jsonDespues varchar(500), @idModified int
	SET @idModified = (SELECT id FROM Inserted)

	SET @jsonAntes = (SELECT [id], [valor], [direccion], [numFinca], [fechaDeIngreso],[M3acumuladosAgua],[M3AcumuladosUltimoRecibo]
					FROM deleted
					FOR JSON PATH)
	SET @jsonDespues = (SELECT [id], [valor], [direccion], [numFinca], [fechaDeIngreso],[M3acumuladosAgua],[M3AcumuladosUltimoRecibo]
					FROM inserted WHERE [activo] = 1
					FOR JSON PATH)
	EXEC [dbo].[SP_BitacoraCambioInsert] @inIdEntityType = 1,@inEntityID = @idModified, @inJsonAntes = @jsonAntes,
													@inJsonDespues = @jsonDespues, @inInsertedBy = 'usuario1', 
													@inInsertedIn = 123
		


