-- Muestra todos los partidos incluyendo los nombres de los equipos
SELECT p.MatchID AS ID, p.Date AS FECHA, home.TeamName AS EQUIPO_LOCAL, away.TeamName AS EQUIPO_VISITANTE, p.HomeTeamScore AS MARCADOR_LOCAL, p.AwayTeamScore AS MARCADOR_VISITANTE
FROM partido p
JOIN equipo home ON p.HomeTeam = home.TeamID
JOIN equipo away ON p.AwayTeam = away.TeamID;





-- Mostrar la segunda mitad de equipos registrados
SELECT * FROM equipo OFFSET ( SELECT (COUNT(*)/2) FROM equipo );





-- Mostrar cantidad de equipos con y sin entrenador
SELECT
    CASE WHEN en.CoachID IS NULL THEN 'Sin entrenador' ELSE 'Con entrenador' END AS estado_entrenador,
    COUNT(e.TeamID) AS cantidad_equipos
FROM equipo e
LEFT JOIN entrenador en ON e.TeamID = en.TeamID
GROUP BY estado_entrenador;






-- Mostrar todos los equipos que tienen o no entrenador
SELECT e.*, en.*
FROM equipo e
LEFT JOIN entrenador en ON e.TeamID = en.TeamID -- La primera consulta realiza un LEFT JOIN entre las tablas "equipo" y "entrenador", seleccionando todos los registros de la tabla "equipo" y los registros correspondientes de la tabla "entrenador". Esto incluye los equipos que tienen entrenador.
UNION ALL -- combina los resultados de ambas consultas en un solo conjunto de resultados, manteniendo todos los registros.
SELECT e.*, en.*
FROM equipo e
RIGHT JOIN entrenador en ON e.TeamID = en.TeamID -- La segunda consulta realiza un RIGHT JOIN entre las tablas "equipo" y "entrenador", seleccionando todos los registros de la tabla "entrenador" y los registros correspondientes de la tabla "equipo". Esto incluye los equipos que no tienen entrenador.
WHERE e.TeamID IS NULL; --seleccionar los equipos que no tienen entrenador. Esto se debe a que en un RIGHT JOIN, los registros no coincidentes de la tabla a la derecha (en este caso, "equipo") tendrán valores NULL en las columnas correspondientes.





-- Obtener la lista de todos los partidos que se hayan jugado a las 2 de la tarde en punto
SELECT CONCAT(EXTRACT(DAY FROM date),'-',EXTRACT(MONTH FROM date),'-',EXTRACT(YEAR FROM date)) AS FECHA, CONCAT(EXTRACT(HOUR FROM date),':',EXTRACT(MINUTE FROM date)) AS HORA, equipo.TeamName AS EQUIPO_LOCAL, equipo2.TeamName AS EQUIPO_VISITANTE, partido.hometeamscore AS MARCADOR_LOCAL, partido.awayteamscore AS MARCADOR_VISITANTE
FROM partido
JOIN equipo ON partido.HomeTeam = equipo.TeamID
JOIN equipo AS equipo2 ON partido.AwayTeam = equipo2.TeamID
WHERE DATE_PART('hour', "date") = 14 AND DATE_PART('minute', "date") = 0;





-- Mostrar todos los registros de jugadores el cual el nombre contenga “José" incluyendo el equipo al que pertenece
SELECT j.PlayerID AS ID, CONCAT(j.PlayerName, ' ', j.lastname1, ' ', j.lastname2) AS NOMBRE_COMPLETO, e.TeamName AS EQUIPO
FROM jugador j
JOIN equipo_jugador ej ON j.PlayerID = ej.PlayerID
JOIN equipo e ON ej.TeamID = e.TeamID
WHERE j.PlayerName LIKE '%José%';





-- Muestra un top ten de los partidos con más goles.
SELECT p.MatchID AS ID, home.TeamName AS EQUIPO_LOCAL, away.TeamName AS EQUIPO_VISITANTE, p.HomeTeamScore AS MARCADOR_LOCAL, p.AwayTeamScore AS MARCADOR_VISITANTE, p.HomeTeamScore + p.AwayTeamScore AS Total_Goles
FROM partido p
JOIN equipo home ON p.HomeTeam = home.TeamID
JOIN equipo away ON p.AwayTeam = away.TeamID
ORDER BY Total_Goles DESC
LIMIT 10;




-- Genera una consulta mostrando los derbies de partidos que se podrían disputar de acuerdo con las ciudades a las que pertenecen los equipos en toda la temporada (ida y vuelta).
SELECT e1.TeamName AS LOCAL, e2.TeamName AS VISITANTE, e1.city AS DERBY_DE --Selecciona las columnas que deseas mostrar en los resultados, en este caso, el nombre del equipo local, el nombre del equipo visitante y ciudad
FROM equipo e1 -- Especifica la tabla "equipo" y asigna un alias "e1" a la misma que representa el equipo local.
JOIN equipo e2 ON e1.City = e2.City -- Realiza un join entre la tabla "equipo" (e2) a sí misma utilizando la columna "City" para comparar las ciudades de los equipos.
AND e1.TeamID != e2.TeamID; -- Agrega una condición adicional para excluir casos en los que el ID del equipo local sea igual al ID del equipo visitante. (REAL MADRID VS REAL MADRID)





-- Genera una tabla general de posiciones mostrando el número de posición, nombre del equipo, partidos jugados, partidos ganados, empates, derrotas, goles a favor, goles en contra, diferencia de goles, puntos.
SELECT -- Comienza la consulta SQL
    ROW_NUMBER() OVER (ORDER BY puntos DESC, diferencia_goles DESC) AS posicion, -- Genera un número de posición para cada equipo, ordenando primero por puntos de forma descendente y luego por diferencia de goles de forma descendente.
    e.TeamName AS nombre_equipo, -- Selecciona el nombre del equipo de la tabla "equipo" y le asigna el alias "nombre_equipo".
    COALESCE(pg.partidos_jugados, 0) AS partidos_jugados, -- Selecciona el número de partidos jugados del equipo, utilizando la función COALESCE=(manejo de valores NULOS) para manejar los casos en los que no haya registros en la subconsulta.
    COALESCE(pg.partidos_ganados, 0) AS partidos_ganados, -- Selecciona el número de partidos ganados del equipo.
    COALESCE(pg.empates, 0) AS empates, -- Selecciona el número de empates del equipo.
    COALESCE(pg.derrotas, 0) AS derrotas, -- Selecciona el número de derrotas del equipo.
    COALESCE(pg.goles_a_favor, 0) AS goles_a_favor, -- Selecciona el número de goles a favor del equipo.
    COALESCE(pg.goles_en_contra, 0) AS goles_en_contra, -- Selecciona el número de goles en contra del equipo. 
    COALESCE(pg.diferencia_goles, 0) AS diferencia_goles, -- Selecciona la diferencia de goles del equipo.
    COALESCE(pg.puntos, 0) AS puntos -- Selecciona la cantidad de puntos del equipo.

FROM equipo e -- Especifica que se seleccionarán los datos de la tabla "equipo" y se le asigna el alias "e".
LEFT JOIN ( --Realiza una unión izquierda con una subconsulta que calcula los datos de la tabla de posiciones. La unión se realiza en base al ID del equipo.
    SELECT -- Realiza los cálculos necesarios para obtener los datos agregados de la tabla de posiciones para cada equipo.
        t.TeamID, -- Selecciona el ID del equipo.
        COUNT(p.MatchID) AS partidos_jugados, --Calcula el número de partidos jugados por el equipo. Utiliza la función COUNT para contar los registros de partidos.
        SUM(CASE WHEN t.TeamID = p.HomeTeam AND p.HomeTeamScore > p.AwayTeamScore THEN 1
                 WHEN t.TeamID = p.AwayTeam AND p.AwayTeamScore > p.HomeTeamScore THEN 1
                 ELSE 0 END) AS partidos_ganados, -- Calcula el número de partidos ganados por el equipo. Utiliza la función SUM junto con la cláusula CASE WHEN para contar los partidos en los que el equipo es el equipo local y tiene un marcador mayor que el equipo visitante, o viceversa.
        SUM(CASE WHEN (t.TeamID = p.HomeTeam AND p.HomeTeamScore = p.AwayTeamScore)
                   OR (t.TeamID = p.AwayTeam AND p.HomeTeamScore = p.AwayTeamScore) THEN 1 ELSE 0 END) AS empates, -- Calcula el número de empates del equipo. Utiliza la función SUM junto con la cláusula CASE WHEN para contar los partidos en los que el equipo es el equipo local y tiene el mismo marcador que el equipo visitante, o viceversa.
        SUM(CASE WHEN (t.TeamID = p.HomeTeam AND p.HomeTeamScore < p.AwayTeamScore)
                   OR (t.TeamID = p.AwayTeam AND p.HomeTeamScore > p.AwayTeamScore) THEN 1 ELSE 0 END) AS derrotas, -- Calcula el número de derrotas del equipo. Utiliza la función SUM junto con la cláusula CASE WHEN para contar los partidos en los que el equipo es el equipo local y tiene una puntuación menor que el equipo visitante, o viceversa.
        SUM(CASE WHEN t.TeamID = p.HomeTeam THEN p.HomeTeamScore ELSE p.AwayTeamScore END) AS goles_a_favor, -- Calcula el total de goles a favor del equipo. Utiliza la función SUM junto con la cláusula CASE WHEN para sumar los goles del equipo como equipo local o como equipo visitante.
        SUM(CASE WHEN t.TeamID = p.HomeTeam THEN p.AwayTeamScore ELSE p.HomeTeamScore END) AS goles_en_contra, -- Calcula el total de goles en contra del equipo. Utiliza la función SUM junto con la cláusula CASE WHEN para sumar los goles en contra del equipo como equipo local o como equipo visitante.
        SUM(CASE WHEN t.TeamID = p.HomeTeam THEN p.HomeTeamScore - p.AwayTeamScore
                 ELSE p.AwayTeamScore - p.HomeTeamScore END) AS diferencia_goles, -- Calcula la diferencia de goles del equipo. Utiliza la función SUM junto con la cláusula CASE WHEN para calcular la diferencia de goles en función de si el equipo es el equipo local o el equipo visitante.
        SUM(CASE WHEN t.TeamID = p.HomeTeam AND p.HomeTeamScore > p.AwayTeamScore THEN 3
                 WHEN t.TeamID = p.AwayTeam AND p.AwayTeamScore > p.HomeTeamScore THEN 3
                 WHEN (t.TeamID = p.HomeTeam AND p.HomeTeamScore = p.AwayTeamScore)
                      OR (t.TeamID = p.AwayTeam AND p.HomeTeamScore = p.AwayTeamScore) THEN 1
                 ELSE 0 END) AS puntos -- Calcula el total de puntos del equipo. Utiliza la función SUM junto con la cláusula CASE WHEN para asignar puntos al equipo en función de los resultados de los partidos.
    FROM equipo t -- Establece la tabla "equipo" como la tabla principal de la subconsulta y la asigna un alias "t".

    LEFT JOIN partido p ON t.TeamID = p.HomeTeam OR t.TeamID = p.AwayTeam
    -- Realiza un LEFT JOIN con la tabla "partido" para unir los registros de partidos que corresponden al equipo como equipo local (HomeTeam) o como equipo visitante (AwayTeam).
    GROUP BY t.TeamID -- Agrupa los resultados por el ID del equipo.
) pg ON e.TeamID = pg.TeamID -- Realiza la unión entre la tabla "equipo" y los datos calculados de la tabla de posiciones utilizando el ID del equipo como condición de unión.
ORDER BY puntos DESC, diferencia_goles DESC; -- Ordena los resultados de forma descendente según los puntos y la diferencia de goles.