# Caso práctico "Fundamentos de bases de datos y SQL"

## Índice
- [Previo](#0-previo)
- [Creación de una base de datos](#1-creación-de-la-base-de-datos)
- [Creación de las tablas](#2-creación-de-las-tablas)

## 0. Previo:
### El sistema gestor de bases de datos relacionales a utilizar es **PostgreSQL** 
### 1. Servicio a utlizar:
#### Es posible utilizar PostgreSQL sin tener que realizar la instalación de un servidor y cliente gracias a ***Supabase***. [Supabase](https://supabase.com/) en un servicio en la nube que permite utilizar bases de datos relacionales.
### 2. Cree una cuenta en Supabase.
#### Acceda al servicio en el siguiente [enlace](https://supabase.com/), después cree una cuenta, puede utilizar su cuenta de GitHub
### 3. Creación de un proyecto
#### Una vez con una cuenta creada puede crear su primer proyecto para poder trabajar con el editor de SQL.

## 1. Creación de la base de datos:
### Si se está utilizando el servicio de Supabase por defecto crea una base de datos, por lo que se puede saltar este paso. Caso contrario, cree una base de datos de nombre "futbol":

```sql
DROP DATABASE IF EXISTS futbol;
CREATE DATABASE IF NOT EXISTS futbol;
```

## 2. Creación de las tablas
### Una vez creada la base de datos, de acuerdo con el siguiente diagrama "*Entididad - Relación*" cree las tablas:

![image](src/diagrama_er.png)

### **Elimine las tablas**: Para evitar problemas de consistencia e integridad de la información con los datos almacenados y sus relaciones mediante las llaves foráneas, para fines prácticos se van a eliminar las tablas para después crearlas:

```sql
DROP TABLE IF EXISTS entrenador;
DROP TABLE IF EXISTS equipo_jugador;
DROP TABLE IF EXISTS partido;
DROP TABLE IF EXISTS equipo;
DROP TABLE IF EXISTS jugador;
```

### 1. Tabla "***equipo***":
```sql
CREATE TABLE IF NOT EXISTS equipo (
	TeamID SERIAL PRIMARY KEY,
    TeamName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL
);
```

### 2. Tabla "***entrenador***":
```sql
CREATE TABLE IF NOT EXISTS entrenador (
	CoachID SERIAL PRIMARY KEY,
    CoachName VARCHAR(100) NOT NULL,
	LastName1 VARCHAR(100) NOT NULL,
	LastName2 VARCHAR(100) NULL,
	TeamID INTEGER REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE
);
```

### 3. Tabla "***jugador***":
```sql
CREATE TABLE IF NOT EXISTS jugador (
	PlayerID SERIAL PRIMARY KEY,
    PlayerName VARCHAR(100) NOT NULL,
	LastName1 VARCHAR(100) NOT NULL,
	LastName2 VARCHAR(100) NULL,
    Position VARCHAR(50) NOT NULL
);
```

### 4. Tabla "***equipo_jugador***":
```sql
CREATE TABLE IF NOT EXISTS equipo_jugador (
	TeamPlayerID SERIAL PRIMARY KEY,
	TeamID INTEGER NOT NULL,
	PlayerID INTEGER NOT NULL
);

ALTER TABLE IF EXISTS equipo_jugador ADD FOREIGN KEY (TeamID) REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (PlayerID) REFERENCES jugador(PlayerID) ON DELETE CASCADE ON UPDATE CASCADE;
```

### 5. Tabla "***partido***":
```sql
CREATE TABLE IF NOT EXISTS partido (
	MatchID SERIAL PRIMARY KEY,
    Date DATE NOT NULL,
	HomeTeam INTEGER REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	AwayTeam INTEGER REFERENCES equipo(TeamID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
	HomeTeamScore SMALLINT NOT NULL,
	AwayTeamScore SMALLINT NOT NULL
);
```

## 3. Inserción de registros