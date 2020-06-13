-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_crearConceptoCobro] @inIdUser INT,@inNombreUser VARCHAR(100), @inDiaCobroUser INT, @inDiasParaVencerUser INT,@inEsRecurrenteUser VARCHAR(2), @inEsFijoUser VARCHAR(2),
											@inTasaImpuestoMoratorioUser float,@inEsImpuestoUser VARCHAR(2), @inMontoUser MONEY, @inValorPorcentualUser float, @inValorPorM3User real,
											@inTipoUser varchar(30) 
AS
BEGIN
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
END
GO
