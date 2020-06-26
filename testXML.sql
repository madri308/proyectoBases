USE [Progra]
DECLARE @XMLData XML, @MinDate DATE, @MaxDate DATE
DECLARE @hdoc INT
SET NOCOUNT ON

--GUARDAR EL XML CON OPENXML
SELECT @XMLData = C
FROM OPENROWSET (BULK 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\p1DATA\xmlData\pruebaProgra2XML.xml', SINGLE_BLOB) AS ReturnData(C)
EXEC sp_xml_preparedocument @hdoc OUTPUT, @XMLData

--CREA TABLA TEMPORAL DE FECHAS
CREATE TABLE #TEMP_DATES_TABLE
(
	id INT IDENTITY(1,1),
    [date] DATE
); 

--INSERTA TODAS LAS FECHA EN LA TABLA TEMPORAL
INSERT INTO #TEMP_DATES_TABLE([date])
	SELECT
		CONVERT(DATE,F.value('@fecha', 'VARCHAR(100)'),126)
	FROM 
		@XmlData.nodes('//OperacionDia') AS ReturnData(F)

--SACA LOS MAXIMOS Y MINIMOS
SELECT 
	@MinDate = min([date]), @MaxDate=max([date])
FROM
	#TEMP_DATES_TABLE

DROP TABLE #TEMP_DATES_TABLE --DEJA LA TABLA

--INSERTAR DATOS
WHILE @MinDate<=@MaxDate
BEGIN
		--INSERTAR PROPIEDADES
		INSERT INTO [dbo].[Propiedad] (valor,direccion,numFinca,fechaDeIngreso)
			SELECT [valor], [direccion],[numFinca],CONVERT(DATE,[fechaDeIngreso],121)[fechaDeIngreso]
			FROM OPENXML (@hdoc, 'Operaciones_por_Dia/OperacionDia/Propiedad',1)  
				WITH (	[valor]			MONEY		'@Valor',  
						[direccion]		VARCHAR(100)	'@Direccion',  
						[numFinca]		int         '@NumFinca',  
						[fechaDeIngreso]	VARCHAR(100)	'../@fecha')
				WHERE fechaDeIngreso = @MinDate
		--ACTUALIZACION DE VALOR PROPIEDAD
		DECLARE @nuevosValProp ValorPropiedadTipo  
		INSERT INTO @nuevosValProp(numFinca,nuevoValor)  
			SELECT [NumFinca],[nuevoValor]
			FROM OPENXML (@hdoc, 'Operaciones_por_Dia/OperacionDia/PropiedadCambio ',1)  
				WITH (	[NumFinca]	VARCHAR(30)	'@NumFinca',  
						[nuevoValor]	MONEY	'@NuevoValor',
						[fechaDeIngreso] )
				WHERE fechaDeIngreso = @MinDate

		--EXEC [dbo].[SP_ProcActualizarValProp] @nuevosValProp
						
	SET @MinDate = dateadd(d,1,@MinDate) --INCREMENTA LA FECHA

END
EXEC sp_xml_removedocument @hdoc  
/*
DELETE PropiedadDelPropietario
DELETE UsuarioDePropiedad
DELETE CCDePropiedad
DELETE PropietarioJuridico
DELETE Propietario
DELETE Propiedad
DELETE Usuario
*/