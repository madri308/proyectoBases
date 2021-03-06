GO
/****** Object:  StoredProcedure [dbo].[SP_UsuarioDePropiedadSelect]    Script Date: 6/2/2020 5:08:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_UsuarioDePropiedadSelect] 
    @id int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [id], [id_Propiedad], [id_Usuario] 
	FROM   [dbo].[UsuarioDePropiedad] 
	WHERE  ([id] = @id OR @id IS NULL) 

	COMMIT
