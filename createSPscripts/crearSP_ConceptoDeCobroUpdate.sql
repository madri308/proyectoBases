GO
/****** Object:  StoredProcedure [dbo].[SP_ConceptoDeCobroUpdate]    Script Date: 6/2/2020 6:43:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ConceptoDeCobroUpdate] 
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
			UPDATE [dbo].[ConceptoDeCobro]
					SET [nombre] = CASE @inNombre
						WHEN '-1' THEN [nombre]
						ELSE @inNombre
					END,
					[diasParaVencer]= CASE @inDiasParaVencer
						WHEN '-1' THEN [diasParaVencer]
						ELSE @inDiasParaVencer
					END,
					[diaDeCobro]= CASE @inDiaDeCobro
						WHEN '-1' THEN [diaDeCobro]
						ELSE @inDiaDeCobro
					END,
					[tasaImpuestoMoratorio]= CASE @inTasaImpuestoMoratorio
						WHEN '-1' THEN [tasaImpuestoMoratorio]
						ELSE @inTasaImpuestoMoratorio
					END,
					[esImpuesto]= CASE @inEsImpuesto
						WHEN '-1' THEN [esImpuesto]
						ELSE @inEsImpuesto
					END,
					[esRecurrente]= CASE @inEsRecurrente
						WHEN '-1' THEN [esRecurrente]
						ELSE @inEsRecurrente
					END,
					[esFijo]= CASE @inEsFijo
						WHEN '-1' THEN [esFijo]
						ELSE @inEsFijo
					END,
					[monto]= CASE @inMonto
						WHEN '-1' THEN [monto]
						ELSE @inMonto
					END
					WHERE [id] = @inId
		END TRY
		BEGIN CATCH
			THROW 51324,'Error: No se ha podido modificar el concepto de cobro',1;
		END CATCH
	COMMIT
