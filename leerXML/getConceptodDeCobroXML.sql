USE [Progra]
DECLARE @XMLData XML, @MinDate DATE, @MaxDate DATE
DECLARE @hdoc INT
SELECT @XMLData = C
FROM OPENROWSET (BULK 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\p1DATA\xmlData\ConceptoDeCobro.xml', SINGLE_BLOB) AS ReturnData(C)
EXEC sp_xml_preparedocument @hdoc OUTPUT, @XMLData

			INSERT INTO [dbo].[ConceptoDeCobro] ([id], [nombre],[diaDeCobro],[diasParaVencer],
				[esRecurrente],[esFijo],[tasaImpuestoMoratorio],[esImpuesto],[monto])
			SELECT [id],[nombre],[diaCobro],[diasParaVencer],[esRecurrente],[esFijo],[tasaImpuestoMoratorio],[esImpuesto],[monto]
			FROM OPENXML (@hdoc,'Conceptos_de_Cobro/conceptocobro', 1)
				WITH(
					[id] int '@id' ,
					[nombre] VARCHAR(100) '@Nombre',
					[diaCobro] int '@DiaCobro',
					[diasParaVencer] int '@QDiasVencimiento',
					[esRecurrente] VARCHAR(2) '@EsRecurrente',
					[esFijo] VARCHAR(2) '@EsFijo',
					[tasaImpuestoMoratorio] float '@TasaInteresMoratoria',
					[esImpuesto] VARCHAR(2) '@EsImpuesto' ,
					[monto] money '@Monto'
					);
					
			--INSERTAR CCPORCENTAJE 
			INSERT INTO [dbo].[CCPorcentaje] ([id],[valorPorcentual])
			SELECT [id],[valorPorcentual]
			FROM OPENXML (@hdoc,'Conceptos_de_Cobro/conceptocobro', 1)
				WITH(
					[id] int '@id',
					[tipo] varchar(30) '@TipoCC',
					[valorPorcentual] float '@ValorPorcentaje')
			WHERE [tipo] = 'CC Porcentual';
			
			--INSERTAR CCFIJO
			INSERT INTO [dbo].[CCFijo] ([id],[Monto])
			SELECT [id],[Monto]
			FROM OPENXML (@hdoc,'Conceptos_de_Cobro/conceptocobro', 1)
				WITH(
					[id] int '@id',
					[Monto] MONEY '@Monto',
					[tipo] varchar(30) '@TipoCC')
			WHERE [tipo] = 'CC Fijo';
			
			--INSERT CCINTERESMORATORIO 
			INSERT INTO [dbo].[CCImpMoratorio] ([id])
			SELECT [id]
			FROM OPENXML (@hdoc,'Conceptos_de_Cobro/conceptocobro', 1)
				WITH(
					[id] int '@id',
					[tipo] varchar(30) '@TipoCC',
					[esFijo] VARCHAR(2) '@EsFijo')
				WHERE [tipo] = 'CC Moratorio';
			
			--INSERTAR CCCONSUMO
			INSERT INTO [dbo].[CCConsumo] ([id],[valorPorM3])
			SELECT [id],[valorPorM3]
			FROM OPENXML (@hdoc,'Conceptos_de_Cobro/conceptocobro', 1)
				WITH(
					[id] int '@id',
					[tipo] varchar(30) '@TipoCC',
					[valorPorM3] real '@ValorM3')
			WHERE [tipo] = 'CC Consumo';

/*
DELETE [dbo].[CCConsumo]
DELETE [dbo].[CCFijo]
DELETE [dbo].[CCImpMoratorio]
DELETE [dbo].[CCPorcentaje]
DELETE [dbo].[ConceptoDeCobro]
*/