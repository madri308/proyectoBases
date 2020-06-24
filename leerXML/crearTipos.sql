USE [Progra]
CREATE TYPE ValorPropiedadTipo AS TABLE (id INT IDENTITY(1,1),numFinca VARCHAR(30),nuevoValor MONEY) 
CREATE TYPE PagosTipo AS TABLE (id INT IDENTITY(1,1),numFinca VARCHAR(30),idTipoRecibo INT) 
