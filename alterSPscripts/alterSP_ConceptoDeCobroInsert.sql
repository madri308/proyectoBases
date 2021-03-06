﻿USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ConceptoDeCobroInsert]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ConceptoDeCobroInsert]  
END 
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
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			INSERT INTO [dbo].[ConceptoDeCobro] ([id], [nombre], [diasParaVencer], [diaDeCobro], [tasaImpuestoMoratorio],[esImpuesto],[esRecurrente],[esFijo],[monto])
			SELECT @inId, @inNombre, @inDiasParaVencer, @inDiaDeCobro, @inTasaImpuestoMoratorio,@inEsImpuesto,@inEsRecurrente,@inEsFijo,@inMonto
			WHERE @inId != '-1' AND @inNombre != '-1' AND @inDiasParaVencer != '-1' AND @inDiaDeCobro != '-1' AND @inTasaImpuestoMoratorio != '-1' AND @inEsImpuesto != '-1' AND @inEsRecurrente != '-1' AND @inEsFijo != '-1' AND @inMonto != '-1'
		END TRY
		BEGIN CATCH
			THROW 50987,'Error: No se ha podido insertar el concepto de cobro',1;
		END CATCH
	END
