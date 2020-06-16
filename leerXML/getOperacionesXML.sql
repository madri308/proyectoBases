USE [Progra]
DECLARE @XMLData XML, @MinDate DATE, @MaxDate DATE
DECLARE @hdoc INT
SET NOCOUNT ON

--GUARDAR EL XML CON OPENXML
SELECT @XMLData = C
FROM OPENROWSET (BULK 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\p1DATA\xmlData\Operaciones2.xml', SINGLE_BLOB) AS ReturnData(C)
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
				
		--INSERTAR PROPIETARIOS
		INSERT INTO [dbo].[Propietario](nombre,valorDocId,identificacion,fechaDeIngreso)
			SELECT [nombre],[TipDocIdRep],[DocidRep],CONVERT(DATE,[fechaDeIngreso1],121)[fechaDeIngreso1]
			FROM OPENXML (@hdoc, 'Operaciones_por_Dia/OperacionDia/Propietario',1) 
				WITH(	[nombre]		VARCHAR(100)		'@Nombre',  
						[TipDocIdRep]	int '@TipoDocIdentidad',  
						[DocidRep]		VARCHAR(100)         '@identificacion',  
						[fechaDeIngreso1]	VARCHAR(100)	'../@fecha')
				WHERE fechaDeIngreso1 = @MinDate 

		--INSERTAR PERSONAS JURIDICAS
		INSERT INTO [dbo].[PropietarioJuridico](id,DocidRepresentante,TipDocIdRepresentante,Representante,docidPersonaJuridica)
			SELECT propietario.id,[DocidRepresentante],[TipDocIdRepresentante],[Representante],[docidPersonaJuridica]
			FROM OPENXML (@hdoc, 'Operaciones_por_Dia/OperacionDia/PersonaJuridica',1)
				WITH(	[DocidRepresentante] VARCHAR(100) '@DocidRepresentante',
						[TipDocIdRepresentante] VARCHAR(100) '@TipDocIdRepresentante',
						[docidPersonaJuridica] VARCHAR(100) '@docidPersonaJuridica',
						[fechaDeIngreso3]	VARCHAR(100)	'../@fecha',
						[Representante]		VARCHAR(100)	'@Nombre')
				INNER JOIN Propietario ON [docidPersonaJuridica] = Propietario.identificacion
				WHERE fechaDeIngreso3 = @MinDate
				
		--INSERTAR PropiedadVersusPropietario
		INSERT INTO [dbo].[PropiedadDelPropietario](id_Propiedad,id_Propietario)
			SELECT [dbo].[Propiedad].[id],[dbo].[Propietario].[id]
			FROM OPENXML(@hdoc, 'Operaciones_por_Dia/OperacionDia/PropiedadVersusPropietario',1)
				WITH(	[numFinca1] VARCHAR(30) '@NumFinca',
						[identificacion1] VARCHAR(30) '@identificacion',
						[fechaDeIngreso4] VARCHAR(100)	'../@fecha')
				INNER JOIN Propiedad ON [numFinca1] = Propiedad.numFinca
				INNER JOIN Propietario ON [identificacion1] = Propietario.identificacion
				WHERE fechaDeIngreso4 = @MinDate
				
		--INSERTAR ConceptoCobroVersusPropiedad
		INSERT INTO [dbo].[CCDePropiedad](id_Propiedad,id_CC,fechaInicio)
			SELECT Propiedad.[id],ConceptoDeCobro.[id],CONVERT(DATE,[fechaDeIngreso5],121)[fechaDeIngreso5]
			FROM OPENXML(@hdoc, 'Operaciones_por_Dia/OperacionDia/ConceptoCobroVersusPropiedad',1)
				WITH(	[numFinca2] VARCHAR(30) '@NumFinca',
						[idcobro] VARCHAR(30) '@idcobro',
						[fechaDeIngreso5] VARCHAR(100)	'../@fecha')
				INNER JOIN Propiedad ON [numFinca2] = Propiedad.numFinca
				INNER JOIN ConceptoDeCobro ON [idcobro] = ConceptoDeCobro.id
				WHERE fechaDeIngreso5 = @MinDate
				
		--INSERTAR Usuarios
		INSERT INTO [dbo].[Usuario]([nombre],[password],[tipoDeUsuario],[fechaDeIngreso])
			SELECT [nombre],[password],'normal',CONVERT(DATE,[fechaDeIngreso6],121)[fechaDeIngreso6]
			FROM OPENXML (@hdoc, 'Operaciones_por_Dia/OperacionDia/Usuario',1) 
				WITH(	[nombre]		VARCHAR(100)		'@Nombre',  
						[password]		VARCHAR(30)		'@password',  
						[fechaDeIngreso6]	VARCHAR(100)	'../@fecha')
				WHERE fechaDeIngreso6 = @MinDate 

		--INSERTAR UsuarioVersusPropiedad
		INSERT INTO [dbo].[UsuarioDePropiedad](id_Propiedad,id_Usuario)
			SELECT Propiedad.[id],Usuario.[id]
			FROM OPENXML(@hdoc, 'Operaciones_por_Dia/OperacionDia/UsuarioVersusPropiedad',1)
				WITH(	[numFinca2] VARCHAR(30) '@NumFinca',
						[nombreUsuario] VARCHAR(30) '@nombreUsuario',
						[fechaDeIngreso7] VARCHAR(100)	'../@fecha')
				INNER JOIN Propiedad ON [numFinca2] = Propiedad.numFinca
				INNER JOIN Usuario ON [nombreUsuario] = Usuario.nombre
				WHERE fechaDeIngreso7 = @MinDate
				
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