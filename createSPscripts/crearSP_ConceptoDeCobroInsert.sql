GO
/****** Object:  StoredProcedure [dbo].[SP_ConceptoDeCobroInsert]    Script Date: 6/2/2020 4:53:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ConceptoDeCobroInsert] 
    @inId int,
    @inNombre varchar(100),
    @inDiasParaVencer int,
    @inDiaDeCobro int,
    @inTasaImpuestoMoratorio float = NULL,
	@inEsImpuesto VARCHAR(2),
	@inEsRecurrente VARCHAR(2),
	@inEsFijo VARCHAR(2),
	@inMonto MONEY
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [dbo].[ConceptoDeCobro] ([id], [nombre], [diasParaVencer], [diaDeCobro], [tasaImpuestoMoratorio],[esImpuesto],[esRecurrente],[esFijo],[monto])
			SELECT @inId, @inNombre, @inDiasParaVencer, @inDiaDeCobro, @inTasaImpuestoMoratorio,@inEsImpuesto,@inEsRecurrente,@inEsFijo,@inMonto
        END TRY
		BEGIN CATCH
			THROW 50987,'Error: No se ha podido insertar el concepto de cobro',1;
		END CATCH
	COMMIT
