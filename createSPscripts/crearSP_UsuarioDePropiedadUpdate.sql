GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioDePropiedadUpdate]    Script Date: 6/2/2020 5:08:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDePropiedadUpdate] 
    @id int,
    @id_Propiedad int,
    @id_Usuario int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[UsuarioDePropiedad]
	SET    [id_Propiedad] = @id_Propiedad, [id_Usuario] = @id_Usuario
	WHERE  [id] = @id

	COMMIT
