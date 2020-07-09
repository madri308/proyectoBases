SELECT P.numFinca, COUNT(*)
FROM [dbo].[Propiedad] P
INNER JOIN [dbo].[CCDePropiedad] CCP ON P.id = CCP.id_Propiedad
GROUP BY P.numFinca
HAVING COUNT(*) > 1