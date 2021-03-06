GO
/****** Object:  StoredProcedure [dbo].[SP_PropietarioJuridicoUpdate]    Script Date: 6/2/2020 5:03:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_PropietarioJuridicoUpdate] 
    @inResponsable varchar(100),
	@inDocIdRespresentante VARCHAR (30),
	@inTipoDocIdRepresentante int,
	@inDocidPersonaJuridica varchar(30)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[PropietarioJuridico]
			SET    [Representante] = @inResponsable, [DocidRepresentante] = @inDocIdRespresentante, [TipDocIdRepresentante] = @inTipoDocIdRepresentante
			WHERE  [docidPersonaJuridica] = @inDocidPersonaJuridica
		END TRY
		BEGIN CATCH
			THROW 73846,'Error: No se ha podido modificar el propietario juridico.',1;
		END CATCH
	COMMIT
