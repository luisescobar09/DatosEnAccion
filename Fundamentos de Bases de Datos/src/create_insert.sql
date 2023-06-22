DROP VIEW IF EXISTS vista_equipo;
DROP TABLE IF EXISTS entrenador;
DROP TABLE IF EXISTS equipo_jugador;
DROP TABLE IF EXISTS partido;

DROP TABLE IF EXISTS equipo;
CREATE TABLE IF NOT EXISTS equipo (
	TeamID SERIAL PRIMARY KEY,
    TeamName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL
);


DROP TABLE IF EXISTS entrenador;
CREATE TABLE IF NOT EXISTS entrenador (
	CoachID SERIAL PRIMARY KEY,
    CoachName VARCHAR(100) NOT NULL,
	LastName1 VARCHAR(100) NOT NULL,
	LastName2 VARCHAR(100) NULL,
	TeamID INTEGER REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS jugador;
CREATE TABLE IF NOT EXISTS jugador (
	PlayerID SERIAL PRIMARY KEY,
    PlayerName VARCHAR(100) NOT NULL,
	LastName1 VARCHAR(100) NOT NULL,
	LastName2 VARCHAR(100) NULL,
    Position VARCHAR(50) NOT NULL
);


DROP TABLE IF EXISTS equipo_jugador;
CREATE TABLE IF NOT EXISTS equipo_jugador (
	TeamPlayerID SERIAL PRIMARY KEY,
	TeamID INTEGER NOT NULL,
	PlayerID INTEGER NOT NULL
);

ALTER TABLE IF EXISTS equipo_jugador ADD FOREIGN KEY (TeamID) REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (PlayerID) REFERENCES jugador(PlayerID) ON DELETE CASCADE ON UPDATE CASCADE;


DROP TABLE IF EXISTS partido;
CREATE TABLE IF NOT EXISTS partido (
	MatchID SERIAL PRIMARY KEY,
    Date TIMESTAMP NOT NULL,
	HomeTeam INTEGER REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	AwayTeam INTEGER REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	HomeTeamScore SMALLINT NOT NULL,
	AwayTeamScore SMALLINT NOT NULL
);

DROP TABLE IF EXISTS pruebas;
CREATE TABLE IF NOT EXISTS pruebas (
	id SERIAL PRIMARY KEY,
	dato VARCHAR(40)
);

------------------------------------------------------------------------------------------------------------------------------

INSERT INTO equipo (teamname, city) 
	VALUES 
		('Real Madrid C.F',	'Madrid'),
		('F.C Barcelona', 'Barcelona'),
		('Atlético de Madrid', 'Madrid'),
		('Real Sociedad', 'San Sebastían'),
		('Villarreal C.F', 'Villarreal'),
		('Real Betis Balompié', 'Sevilla'),
		('Athletic Club Athletic', 'Villa de Bilbao'),
		('Valencia C.F', 'Valencia'),
		('Sevilla F.C'	, 'Sevilla'),
		('R.C Celta de Vigo', 'Vigo'),
		('Getafe C.F', 'Madrid'),
		('C.A Osasuna', 'Pamplona'),
		('Girona F.C', 'Gerona'),
		('Rayo Vallecano', 'Madrid'),
		('R.C.D Espanyol', 'Barcelona'),
		('R.C.D Mallorca', 'Mallorca'),
		('U.D Almería', 'Almería'),
		('Real Valladolid C.F', 'Valladolid'),
		('Cádiz C.F', 'Cádiz'),
		('Elche C.F', 'Valencia')
;

INSERT INTO entrenador (CoachName, LastName1, LastName2, TeamID) 
  VALUES 
    ('Carlo', 'Ancelotti', '', 1),
    ('Xavi', 'Hernández', 'Creus', 2),
    ('Diego Pablo', 'Simeone', '', 3),
    ('Imanol', 'Alguacil', 'Barrenetxea', 4),
    ('Enrique', 'Setién', 'Solar', 5),
    ('Manuel Luis', 'Pellegrini', 'Ripamonti', 6),
    ('Ernesto', 'Valverde', 'Tejedor', 7),
    ('Javier', 'Aguirre', 'Onaindía', 16)
;

INSERT INTO jugador (PlayerName, LastName1, LastName2, Position) 
  VALUES

    ('Thibaut Nicolas', 'Marc', 'Courtois', 'portero'),
    ('Éder Gabriel', 'Militão', '', 'defensa'),
    ('David ', 'Olatukunbo', 'Alaba', 'defensa'),
    ('Ferland ', 'Sinna', 'Mendy', 'defensa'),
    ('Lucas', 'Vázquez', 'Iglesias', 'defensa'),
    ('Toni', 'Kroos', '', 'mediocampista'),
    ('Luka ', 'Modrić', '', 'mediocampista'),
    ('Federico Santiago', 'Valverde', 'Dipetta', 'mediocampista'),
    ('Vinicius José', 'Paixão', 'de Oliveira Junior', 'delantero'),
    ('Rodrygo', 'Silva', 'de Goes', 'delantero'),
    ('Karim', 'Benzema', '', 'delantero'),
    ('Aurélien', 'Djani', 'Tchouaméni', 'mediocampista'),

    ('Marc-André', 'ter Stegen', '', 'portero'),
    ('Ronald Federico', 'Araújo', 'da Silva', 'defensa'),
    ('Alejandro', 'Balde', 'Martínez', 'defensa'),
    ('Jules Olivier', 'Kounde', '', 'defensa'),
    ('Jordi', 'Alba', 'Ramos', 'defensa'),
    ('Pedro', 'González', 'López', 'mediocampista'),
    ('Pablo Martín', 'Páez', 'Gavira', 'mediocampista'),
    ('Frenkie', 'de Jong', '', 'mediocampista'),
    ('Masour', 'Ousmane', 'Dembélé', 'delantero'),
    ('Raphael', 'Dias', 'Belloli', 'delantero'),
    ('Robert', 'Lewandowski', '', 'delantero'),
    ('Anssumane', 'Fati', 'Vieira', 'delantero'),

    ('Nahuel', 'Molina', 'Lucero', 'defensa'), --ATLETICO DE MADRID
    ('Antoine', 'Griezmann', '', 'delantero'),
    ('Memphis ', 'Depay', '', 'delantero'),
    ('Alex Nicolao', 'Telles', '', 'defensa'), -- SEVILLA
    ('Jesús Manuel', 'Corona', 'Ruíz', 'delantero'),
    ('Guido', 'Rodríguez', '', 'mediocampista'), -- REAL BETIS
    ('José Andrés', 'Guardado', 'Hernández', 'mediocampista'),
    ('Claudio Andrés', 'Bravo', 'Muñoz', 'portero'),
    ('Nabil', 'Fekir', '', 'mediocampista'),
    ('César Jasib', 'Montes', 'Castro', 'defensa'), -- Espanyol 
    ('Denis', 'Suárez', 'Fernández', 'mediocampista'),
    ('Martin', 'Christensen', 'Braithwaite', 'delantero')   
;


INSERT INTO equipo_jugador (TeamID, PlayerID)
  VALUES
    
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (1, 10),
    (1, 11),
    (1, 12),

    (2, 13),
    (2, 14),
    (2, 15),
    (2, 16),
    (2, 17),
    (2, 18),
    (2, 19),
    (2, 20),
    (2, 21),
    (2, 22),
    (2, 23),
    (2, 24),

    (3, 25),
    (3, 26),
    (3, 27),

    (9, 28),
    (9, 29),
    
    (6, 30),
    (6, 31),
    (6, 32),
    (6, 33),

    (15, 34),
    (15, 35),
    (15, 36)
;



INSERT INTO partido (Date, HomeTeam, AwayTeam, HomeTeamScore, AwayTeamScore) 
  VALUES

    ('2022-10-07 14:00:00', 12, 8, 1, 2),
    ('2022-10-08 07:00:00', 17, 14, 3, 1),
    ('2022-10-08 09:15:00', 3, 13, 2, 1),
    ('2022-10-08 11:30:00', 9, 7, 1, 1),
    ('2022-10-08 14:00:00', 11, 1, 0, 1),
    ('2022-10-09 07:00:00', 18, 6, 0, 0),
    ('2022-10-09 09:15:00', 19, 15, 2, 2),
    ('2022-10-09 11:30:00', 4, 5, 1, 0),
    ('2022-10-09 14:00:00', 2, 10, 1, 0),
    ('2022-10-10 14:30:00', 20, 16, 1, 1),


    ('2022-10-14 14:00:00', 14, 11, 0, 0),
    ('2022-10-15 07:00:00', 13, 19, 1, 1),
    ('2022-10-15 09:15:00', 8, 20, 2, 2),
    ('2022-10-15 11:30:00', 16, 9, 0, 1),
    ('2022-10-15 14:00:00', 7, 3, 0, 1),
    ('2022-10-16 07:00:00', 10, 4, 1, 2),
    ('2022-10-16 09:15:00', 1, 2, 3, 1),
    ('2022-10-16 11:30:00', 15, 18, 1, 0),
    ('2022-10-16 14:00:00', 6, 17, 3, 1),
    ('2022-10-17 14:00:00', 5, 12, 2, 0),


    ('2023-06-04 10:30:00', 16, 14, 3, 0),
    ('2023-06-04 10:30:00', 12, 13, 2, 1),
    ('2023-06-04 10:30:00', 1, 7, 1, 1),
    ('2023-06-04 10:30:00', 4, 9, 2, 1),
    ('2023-06-04 10:30:00', 5, 3, 2, 2),
    ('2023-06-04 10:30:00', 10, 2, 2, 1),
    ('2023-06-04 10:30:00', 20, 19, 1, 1),
    ('2023-06-04 10:30:00', 15, 17, 3, 3),
    ('2023-06-04 10:30:00', 6, 8, 1, 1),
    ('2023-06-04 10:30:00', 18, 11, 0, 0)
;

INSERT INTO pruebas (dato) 
  VALUES
    ('HOLA'),
    ('ESTO'),
    ('ES'),
    ('UNA'),
    ('PRUEBA'),
    (':)')
;