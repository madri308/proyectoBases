USE [Progra]
GO
IF OBJECT_ID('[dbo].[SP_ProcGeneraRecibos]') IS NOT NULL
BEGIN 
    DROP PROC [dbo].[SP_ProcGeneraRecibos]  
END 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_ProcGeneraRecibos] @fecha DATE
AS  	
	BEGIN
		BEGIN TRY
		SET NOCOUNT ON 
		SET XACT_ABORT ON
			DECLARE @dia int
			SET @dia  = DAY(@fecha)
			INSERT INTO [dbo].[Recibos](id_CC,monto,estado,id_Propiedad,fecha,fechaVence)
			SELECT 
				CC.id,
				CASE	WHEN (CC.esFijo = 'Si' AND CC.id != 1) THEN CC.monto 
						WHEN (CC.esImpuesto = 'Si') THEN P.valor/100*CCPo.valorPorcentual
						WHEN (CC.id = 1) THEN 
								CASE WHEN (P.M3acumuladosAgua-P.M3AcumuladosUltimoRecibo)*CCC.valorPorM3>CCC.montoMinimoRecibo
								THEN (P.M3acumuladosAgua-P.M3AcumuladosUltimoRecibo)*CCC.valorPorM3
								ELSE CCC.montoMinimoRecibo END
						END,
				0,
				P.id,
				@fecha,
				DATEADD(d,CC.diasParaVencer,@fecha)
			FROM [dbo].[CCDePropiedad] CCP 
			INNER JOIN [dbo].[ConceptoDeCobro] CC ON CCP.id_CC = CC.id
			INNER JOIN [dbo].[Propiedad] P ON CCP.id_Propiedad = P.id
			FULL OUTER JOIN [dbo].[CCPorcentaje] CCPo ON CCPo.id = CC.id
			FULL OUTER JOIN [dbo].[CCConsumo] CCC ON CCC.id = CC.id
			WHERE CC.diaDeCobro = @dia
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			THROW 550834,'Error: No se ha podido generar el recibo',1;
		END CATCH	
	END