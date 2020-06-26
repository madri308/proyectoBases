;WITH P AS(
			SELECT [nombre],[TipDocIdRep],[DocidRep],CONVERT(DATE,[fechaDeIngreso1],121)[fechaDeIngreso1]
			FROM OPENXML (@hdoc, 'Operaciones_por_Dia/OperacionDia/Propietario',1) 
				WITH(	[nombre]		VARCHAR(100)		'@Nombre',  
						[TipDocIdRep]	int '@TipoDocIdentidad',  
						[DocidRep]		VARCHAR(100)         '@identificacion',  
						[fechaDeIngreso1]	VARCHAR(100)	'../@fecha')
				WHERE fechaDeIngreso1 = @MinDate
		)