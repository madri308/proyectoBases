USE [Progra]
CREATE TYPE ConsumoTipo AS TABLE (id INT IDENTITY(1,1),numFinca VARCHAR(30),LecturaMedidorM3 INT, Fecha DATE) 
CREATE TYPE AjustesConsumoTipo AS TABLE (id INT IDENTITY(1,1),numFinca VARCHAR(30),M3 INT, Razon VARCHAR(30), Fecha DATE) 
CREATE TYPE ValorPropiedadTipo AS TABLE (id INT IDENTITY(1,1),numFinca VARCHAR(30),nuevoValor MONEY) 
CREATE TYPE PagosTipo AS TABLE (id INT IDENTITY(1,1),numFinca VARCHAR(30),idTipoRecibo INT) 
