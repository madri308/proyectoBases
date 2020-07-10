USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_crearConceptoCobro]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_crearConceptoCobro]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_crearConceptoCobro] @inIdUser INT,@inNombreUser VARCHAR(100), @inDiaCobroUser INT, @inDiasParaVencerUser INT,@inEsRecurrenteUser VARCHAR(2), @inEsFijoUser VARCHAR(2),
											@inTasaImpuestoMoratorioUser float,@inEsImpuestoUser VARCHAR(2), @inMontoUser MONEY, @inValorPorcentualUser float, @inValorPorM3User real,
											@inTipoUser varchar(30) 
AS
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON;
			IF EXISTS(SELECT @inIdUser FROM [dbo].[ConceptoDeCobro])
				return -1
			ELSE
				BEGIN TRAN
					EXEC [dbo].[SP_ConceptoDeCobroInsert] @inId = @inIdUser, @inNombre = @inNombreUser, @inDiasParaVencer = @inDiasParaVencerUser,
														@inDiaDeCobro = @inDiaCobroUser, @inTasaImpuestoMoratorio = @inTasaImpuestoMoratorioUser,
														@inEsImpuesto = @inEsImpuestoUser, @inEsRecurrente = @inEsRecurrenteUser, @inEsFijo = @inEsFijoUser,
														@inMonto = @inMontoUser
					IF @inTipoUser = 'fijo'
						EXEC [dbo].[SP_CCFijoInsert] @inId = @inIdUser, @inMonto = @inMontoUser
					ELSE IF @inTipoUser = 'consumo'
						EXEC [dbo].[SP_CCConsumoInsert] @inId = @inIdUser, @inValorPorM3 = @inValorPorM3User
					ELSE IF @inTipoUser = 'porcentual'
						EXEC [dbo].[SP_CCPorcentajeInsert] @inId = @inIdUser, @inValorPorcentual = @inValorPorcentualUser
					ELSE
						EXEC [dbo].[SP_CCImpMoratorioInsert] @inId = @inIdUser
				COMMIT
		END TRY
		BEGIN CATCH
			If @@TRANCOUNT > 0 
				ROLLBACK TRAN;
			THROW 73693,'Error: No se pudo crear el concepto de cobro.',1;
		END CATCH
	END
