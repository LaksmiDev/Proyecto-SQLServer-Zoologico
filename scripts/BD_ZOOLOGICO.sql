-- FINAL_BD_ZOOLOGICO.sql

CREATE DATABASE Zoologico;
GO

-- Usar la base de datos Zoologico
USE Zoologico;
GO

CREATE TABLE HABITAT
(
    CodHab INT NOT NULL,
    DescHab VARCHAR(100) NOT NULL,
    NomHab VARCHAR(30) NOT NULL,
    AniHabi INT NOT NULL, 
    PRIMARY KEY (CodHab)
);
GO

CREATE TABLE ESPECIE
(
    CodEspe INT NOT NULL,
    NomEspe VARCHAR(30) NOT NULL,
    DescEspe VARCHAR(100) NOT NULL,
    CodHabitat INT NOT NULL,
    PRIMARY KEY (CodEspe),
    CONSTRAINT UQ_ESPECIE_NomEspe UNIQUE (NomEspe),
    CONSTRAINT FK_ESPECIE_HABITAT FOREIGN KEY (CodHabitat) REFERENCES HABITAT(CodHab)
);
GO

CREATE TABLE ALIMENTO 
(
    CodAlim INT NOT NULL,
    TipoAlim CHAR(1) NOT NULL,
    CantAlim INT NOT NULL, 
    FrecAlim CHAR(1) NOT NULL, 
    PRIMARY KEY (CodAlim)
);
GO

CREATE TABLE ANIMAL
(
    CodAnimal INT NOT NULL,
    NomAnimal VARCHAR(30) NOT NULL,
    EdAnimal CHAR(1) NOT NULL,
    GenAnimal CHAR(1) NOT NULL, 
    FechaNacimiento DATE NOT NULL,
    Foto IMAGE,
    Estado INT NOT NULL,
    CodEspe INT NOT NULL,
    CodAlim INT NOT NULL,
    CodHab INT NOT NULL,
    PRIMARY KEY (CodAnimal),
    CONSTRAINT CHK_ANIMAL_EdAnimal CHECK (EdAnimal IN ('J', 'A', 'N')),--joven, adulto, anciano 
    CONSTRAINT FK_ANIMAL_ESPECIE FOREIGN KEY (CodEspe) REFERENCES ESPECIE(CodEspe),
    CONSTRAINT FK_ANIMAL_ALIMENTO FOREIGN KEY (CodAlim) REFERENCES ALIMENTO(CodAlim),
    CONSTRAINT FK_ANIMAL_HABITAT FOREIGN KEY (CodHab) REFERENCES HABITAT(CodHab)
);
GO

CREATE TABLE UBIGEO
(
    Id_Ubigeo CHAR(6) NOT NULL, 
    IdDepa NVARCHAR(255) NULL,
    IdProv NVARCHAR(255) NULL,
    IdDis NVARCHAR(255) NULL, 
    Departamento NVARCHAR(255) NULL,
    Provincia NVARCHAR(255) NULL,
    Distrito NVARCHAR(255) NULL,
    PRIMARY KEY (Id_Ubigeo)
);
GO

CREATE TABLE VETERINARIO
(
    IdVet INT NOT NULL,
    ApeVet VARCHAR(30) NOT NULL,
    NomVet VARCHAR(30) NOT NULL,
    EspecVet CHAR(1) NOT NULL,
    Direccion VARCHAR(100) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Id_Ubigeo CHAR(6) NOT NULL,
    Foto IMAGE,
    FechaIngreso DATE NOT NULL,
    Estado INT NOT NULL,
    PRIMARY KEY (IdVet),
    CONSTRAINT UQ_VETERINARIO_NomApeVet UNIQUE (NomVet, ApeVet),
    FOREIGN KEY (Id_Ubigeo) REFERENCES UBIGEO(Id_Ubigeo)
);
GO

CREATE TABLE ANIMAL_VETERINARIO 
(
    CodAnimal INT NOT NULL,
    IdVet INT NOT NULL,
    MedAdm VARCHAR(30) NOT NULL,
    TiemAten CHAR(1) NOT NULL,
    PRIMARY KEY (CodAnimal, IdVet),
    FOREIGN KEY (CodAnimal) REFERENCES ANIMAL(CodAnimal),
    FOREIGN KEY (IdVet) REFERENCES VETERINARIO(IdVet)
);
GO

CREATE TABLE PERSONAL
(
    IdPer INT NOT NULL,
    PuestoPer CHAR(1) NOT NULL,
    NomPer VARCHAR(30) NOT NULL,
    ApePer VARCHAR(30) NOT NULL, 
    Direccion VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    FechaIngreso DATE NOT NULL,
    Foto IMAGE,
    Estado INT NOT NULL,
    NumTelPer VARCHAR(9) NOT NULL,
    CorrElecPer VARCHAR(50) NOT NULL,
    Id_Ubigeo CHAR(6) NOT NULL,
    PRIMARY KEY (IdPer),
    FOREIGN KEY (Id_Ubigeo) REFERENCES UBIGEO(Id_Ubigeo),
    CONSTRAINT UQ_PERSONAL_CorrElecPer UNIQUE (CorrElecPer) 
);
GO

CREATE TABLE ANIMAL_PERSONAL 
(
    CodAnimal INT NOT NULL,
    IdPer INT NOT NULL,
    TiemCuid VARCHAR(10) NOT NULL,
    PRIMARY KEY (CodAnimal, IdPer),
    FOREIGN KEY (CodAnimal) REFERENCES ANIMAL(CodAnimal),
    FOREIGN KEY (IdPer) REFERENCES PERSONAL(IdPer)
);
GO

CREATE TABLE RECORRIDO 
(
    NroReco INT NOT NULL,
    NomReco VARCHAR(100) NOT NULL,
    DescReco VARCHAR(100) NOT NULL,
    AniExhiRec INT NOT NULL,
    PRIMARY KEY (NroReco)
);
GO

CREATE TABLE DETALLE_RECORRIDO
(
    CodAnimal INT NOT NULL,
    NroReco INT NOT NULL,
    CodHab INT NOT NULL,
    PRIMARY KEY (CodAnimal, NroReco),
    FOREIGN KEY (CodAnimal) REFERENCES ANIMAL(CodAnimal),
    FOREIGN KEY (NroReco) REFERENCES RECORRIDO(NroReco),
    FOREIGN KEY (CodHab) REFERENCES HABITAT(CodHab) 
);
GO

CREATE TABLE VISITANTE 
(
    IdVisit INT NOT NULL,
    DirecVisit VARCHAR(30) NOT NULL,
    NomVisit VARCHAR(30) NOT NULL,
    ApeVisit VARCHAR(30) NOT NULL,
    CorrElectVisit VARCHAR(30) NOT NULL,
    Id_Ubigeo CHAR(6) NOT NULL,
    PRIMARY KEY (IdVisit),
    FOREIGN KEY (Id_Ubigeo) REFERENCES UBIGEO(Id_Ubigeo),
    CONSTRAINT UQ_VISITANTE_CorrElectVisit UNIQUE (CorrElectVisit) 
);
GO

CREATE TABLE ENTRADA 
(
    CodEntr INT NOT NULL,
    TipoEntr CHAR(1) NOT NULL,
    FechaCom DATE NOT NULL,
    HoraCom TIME NOT NULL,
    PrecioEntr DECIMAL(10,2) NOT NULL, 
    NroReco INT NOT NULL,
    IdVisit INT NOT NULL,
    Id_Ubigeo CHAR(6) NOT NULL,
    PRIMARY KEY (CodEntr),
    CONSTRAINT CHK_ENTRADA_TipoEntr CHECK (TipoEntr IN ('V', 'G', 'N')), --vip, general, niños
    FOREIGN KEY (NroReco) REFERENCES RECORRIDO(NroReco),
    FOREIGN KEY (IdVisit) REFERENCES VISITANTE(IdVisit),
    FOREIGN KEY (Id_Ubigeo) REFERENCES UBIGEO(Id_Ubigeo)
);
GO


--Creacion de Vistas:
--Creacion de la vista Especie
CREATE OR ALTER VIEW vw_EspeciesInfo AS
SELECT E.CodEspe, E.NomEspe, E.DescEspe, H.NomHab, H.DescHab
FROM 
    ESPECIE E
INNER JOIN 
    HABITAT H ON E.CodHabitat = H.CodHab;
GO

--Creacion de la vista Habitat
CREATE OR ALTER VIEW vw_Habitat AS 
SELECT Hab.CodHab, Hab.DescHab, Hab.NomHab, Hab.AniHabi
FROM
HABITAT HAB;
GO

--Creacion de la vista Alimento
CREATE OR ALTER VIEW vw_AlimentosInfo AS
SELECT Al.CodAlim, Al.TipoAlim, Al.CantAlim, Al.FrecAlim
FROM 
    ALIMENTO Al;
GO

--Creacion de la vista Veterinario

CREATE OR ALTER VIEW vw_VeterinariosInfo AS
SELECT  V.IdVet, V.NomVet, V.ApeVet, V.EspecVet, V.Direccion, V.Email, U.Departamento, U.Provincia, U.Distrito, V.FechaIngreso, V.Estado,
    CASE 
        WHEN V.Estado = '1' THEN 'Disponible'
        WHEN V.Estado = '0' THEN 'No Disponible'
        ELSE 'Desconocido'
    END AS EstadoVeterinario
FROM 
    VETERINARIO V
INNER JOIN 
    UBIGEO U ON V.Id_Ubigeo = U.Id_Ubigeo;
GO


--Creacion de la vista Personal
CREATE OR ALTER VIEW vw_PersonalInfo AS
SELECT P.IdPer, P.PuestoPer, P.NomPer, P.ApePer, P.Direccion, P.FechaNacimiento, P.FechaIngreso, P.NumTelPer, P.CorrElecPer, U.Departamento, U.Provincia, U.Distrito,
    CASE 
        WHEN P.Estado = '1' THEN 'Empleado'
        WHEN P.Estado = '0' THEN 'No Empleado'
        ELSE 'Desconocido'
    END AS EstadoPersonal
FROM 
    PERSONAL P
INNER JOIN 
    UBIGEO U ON P.Id_Ubigeo = U.Id_Ubigeo;
GO

--Creacion de la vista Entrada
CREATE OR ALTER VIEW vw_EntradasInfo AS
SELECT E.CodEntr, E.TipoEntr, E.FechaCom, E.HoraCom, E.PrecioEntr, V.NomVisit, V.ApeVisit, U.Departamento, U.Provincia, U.Distrito,
    CASE 
        WHEN E.TipoEntr = 'V' THEN 'Entrada Especial'
        WHEN E.TipoEntr = 'G' THEN 'Entrada Común'
        WHEN E.TipoEntr = 'N' THEN 'Entrada Infantil'
        ELSE 'Tipo Desconocido'
    END AS TipoEntrada
FROM 
    ENTRADA E
INNER JOIN 
    VISITANTE V ON E.IdVisit = V.IdVisit
INNER JOIN 
    UBIGEO U ON E.Id_Ubigeo = U.Id_Ubigeo;
GO


--Creacion de los Indices:
--INDICE DE HABITAT

execute sp_helpindex 'HABITAT'

CREATE INDEX IX_HABITAT_DescHab ON HABITAT (DescHab)

CREATE INDEX IX_HABITAT_NomHab  ON HABITAT (NomHab)

--INDICE DE ESPECIE

execute sp_helpindex 'ESPECIE'

CREATE INDEX IX_ESPECIE_CodHabitat ON ESPECIE (CodHabitat)

CREATE INDEX IX_ESPECIE_NomEspe    ON ESPECIE (NomEspe)

-- INDICE ALIMENTO
execute sp_helpindex 'ALIMENTO'
 

CREATE INDEX IX_ALIMENTO_TipoAlim  ON ALIMENTO (TipoAlim)

CREATE INDEX IX_ALIMENTO_CantAlim  ON ALIMENTO (CantAlim)

--ANIMAL 
execute sp_helpindex 'ANIMAL'


CREATE INDEX IX_ANIMAL_CodEspe  ON ANIMAL (CodEspe)

CREATE INDEX IX_ANIMAL_Estado   ON ANIMAL (Estado)

--UBIGEO 
execute sp_helpindex 'UBIGEO'


CREATE INDEX IX_UBIGEO_Departamento  ON UBIGEO (Departamento)

CREATE INDEX IX_UBIGEO_Provincia     ON UBIGEO (Provincia)

CREATE INDEX IX_UBIGEO_Distrito ON UBIGEO (Distrito)

--VETERINARIO INDICE
execute sp_helpindex 'VETERINARIO'


CREATE INDEX IX_VETERINARIO_Especialidad  ON VETERINARIO (EspecVet)

CREATE INDEX IX_VETERINARIO_Email    ON VETERINARIO (Email)

--ANIMAL_VETERINARIO INDICE 
execute sp_helpindex 'ANIMAL_VETERINARIO'


CREATE INDEX IX_ANIMAL_VETERINARIO_CodAnimal  ON ANIMAL_VETERINARIO (CodAnimal)

CREATE INDEX IX_ANIMAL_VETERINARIO_IdVet   ON ANIMAL_VETERINARIO (IdVet)

--Personal Indice
execute sp_helpindex 'PERSONAL'


CREATE INDEX IX_PERSONAL_PuestoPer   ON PERSONAL (PuestoPer)

CREATE INDEX IX_PERSONAL_CorrElecPer ON PERSONAL (CorrElecPer)

-- ANIMAL_PERSONAL INDICE
execute sp_helpindex 'ANIMAL_PERSONAL'


CREATE INDEX IX_ANIMAL_PERSONAL_CodAnimal ON ANIMAL_PERSONAL (CodAnimal)

CREATE INDEX IX_ANIMAL_PERSONAL_IdPer  ON ANIMAL_PERSONAL (IdPer)

-- RECORRIDO INDICE
execute sp_helpindex 'RECORRIDO'


CREATE INDEX IX_RECORRIDO_NomReco ON RECORRIDO (NomReco)

CREATE INDEX IX_RECORRIDO_AniExhiRec ON RECORRIDO (AniExhiRec)

-- DETALLE_RECORRIDO INDICE
execute sp_helpindex 'DETALLE_RECORRIDO'


CREATE INDEX IX_DETALLE_RECORRIDO_NroReco  ON DETALLE_RECORRIDO (NroReco)

CREATE INDEX IX_DETALLE_RECORRIDO_CodHab  ON DETALLE_RECORRIDO (CodHab)

-- VISITANTE INIDICE
execute sp_helpindex 'VISITANTE'


CREATE INDEX IX_VISITANTE_NomVisit  ON VISITANTE (NomVisit)

CREATE INDEX IX_VISITANTE_CorrElectVisit ON VISITANTE (CorrElectVisit)

-- ENTRADA INDICE

execute sp_helpindex 'ENTRADA'

CREATE INDEX IX_ENTRADA_TipoEntr ON ENTRADA (TipoEntr)

CREATE INDEX IX_ENTRADA_FechaCom  ON ENTRADA (FechaCom)


-- Insertando registros de prueba:
-- Insertar datos en HABITAT
INSERT INTO HABITAT (CodHab, DescHab, NomHab, AniHabi) 
VALUES 
(1, 'Sabana africana', 'Sabana', 10),
(2, 'Selva amazónica', 'Selva', 20),
(3, 'Desierto del Sahara', 'Desierto', 5),
(4, 'Montañas Rocosas', 'Montañas', 8),
(5, 'Bosque templado', 'Bosque', 15),
(6, 'Pantano del Everglades', 'Pantano', 7),
(7, 'Islas Galápagos', 'Islas', 12),
(8, 'Tundra ártica', 'Tundra', 4),
(9, 'Praderas de América del Norte', 'Pradera', 9),
(10, 'Región mediterránea', 'Mediterráneo', 6),
(11, 'Bosque boreal', 'Boreal', 11),
(12, 'Sabana asiática', 'Sabana Asiática', 10),
(13, 'Bosque lluvioso tropical', 'Lluvioso', 14),
(14, 'Desierto de Gobi', 'Gobi', 3),
(15, 'Montañas del Himalaya', 'Himalaya', 7),
(16, 'Selva de Borneo', 'Borneo', 13),
(17, 'Estepa siberiana', 'Estepa', 5),
(18, 'Bosque de coníferas', 'Coníferas', 12),
(19, 'Manglares costeros', 'Manglar', 6),
(20, 'Reserva de coral', 'Coral', 9);
GO

-- Insertar datos en ESPECIE
INSERT INTO ESPECIE (CodEspe, NomEspe, DescEspe, CodHabitat) 
VALUES 
(1, 'León', 'Felino de gran tamaño', 1),
(2, 'Tigre', 'Felino de rayas naranjas y negras', 2),
(3, 'Elefante', 'Mamífero terrestre más grande', 1),
(4, 'Cebra', 'Equino rayado', 1),
(5, 'Jirafa', 'Mamífero de cuello largo', 1),
(6, 'Oso polar', 'Gran carnívoro ártico', 8),
(7, 'Lince', 'Felino salvaje de tamaño mediano', 5),
(8, 'Rinoceronte', 'Mamífero con uno o dos cuernos', 3),
(9, 'Pingüino', 'Ave no voladora acuática', 20),
(10, 'Koala', 'Marsupial arborícola', 12),
(11, 'Panda', 'Oso con manchas negras y blancas', 13),
(12, 'Lobo', 'Canino salvaje', 9),
(13, 'Gorila', 'Primates grandes y fuertes', 2),
(14, 'Hipopótamo', 'Mamífero semiaquático', 6),
(15, 'Cocodrilo', 'Reptil grande y depredador', 6),
(16, 'Águila', 'Ave rapaz de gran tamaño', 10),
(17, 'Serpiente Boa', 'Reptil constrictor', 4),
(18, 'Tucán', 'Ave con pico colorido', 17),
(19, 'Mariposa Monarca', 'Insecto migratorio', 19),
(20, 'Tortuga Marina', 'Reptil acuático de caparazón duro', 20);
GO

-- Insertar datos en ALIMENTO
INSERT INTO ALIMENTO (CodAlim, TipoAlim, CantAlim, FrecAlim)
VALUES 
(1, 'F', 50, 'D'),
(2, 'C', 200, 'M'),
(3, 'V', 30, 'D'),
(4, 'P', 100, 'S'),
(5, 'H', 150, 'M'),
(6, 'G', 120, 'D'),
(7, 'I', 200, 'S'),
(8, 'N', 80, 'D'),
(9, 'A', 30, 'M'),
(10, 'R', 50, 'D'),
(11, 'F', 60, 'M'),
(12, 'P', 40, 'D'),
(13, 'B', 70, 'D'),
(14, 'P', 200, 'S'),
(15, 'N', 60, 'M'),
(16, 'C', 90, 'D'),
(17, 'S', 110, 'M'),
(18, 'L', 150, 'S'),
(19, 'C', 50, 'M'),
(20, 'B', 40, 'D');
GO

-- Insertar datos en ANIMAL
INSERT INTO ANIMAL (CodAnimal, NomAnimal, EdAnimal, GenAnimal, FechaNacimiento, Foto, Estado, CodEspe, CodAlim, CodHab)
VALUES 
(1, 'Jaguar', 'A', 'M', '2015-08-15', NULL, 1, 1, 1, 1),
(2, 'Águila real', 'A', 'F', '2010-05-10', NULL, 2, 2, 2, 2),
(3, 'Panda gigante', 'J', 'F', '2022-02-01', NULL, 3, 3, 3, 3),
(4, 'Cebra', 'A', 'M', '2018-07-05', NULL, 4, 4, 4, 4),
(5, 'León', 'A', 'M', '2012-12-20', NULL, 5, 5, 5, 5),
(6, 'Tigre', 'J', 'F', '2023-01-10', NULL, 6, 6, 6, 6),
(7, 'Elefante africano', 'A', 'M', '2015-11-30', NULL, 7, 7, 7, 7),
(8, 'Llama', 'J', 'F', '2023-03-21', NULL, 8, 8, 8, 8),
(9, 'Canguro', 'A', 'M', '2010-05-10', NULL, 9, 9, 9, 9),
(10, 'Gorila', 'A', 'M', '2013-02-19', NULL, 10, 10, 10, 10),
(11, 'Pingüino', 'J', 'F', '2022-09-11', NULL, 11, 11, 11, 11),
(12, 'Tucán', 'A', 'F', '2014-06-15', NULL, 12, 12, 12, 12),
(13, 'Oso polar', 'J', 'M', '2022-01-25', NULL, 13, 13, 13, 13),
(14, 'Crocodilo', 'A', 'M', '2011-03-12', NULL, 14, 14, 14, 14),
(15, 'Puma', 'A', 'M', '2016-09-09', NULL, 15, 15, 15, 15),
(16, 'Pavo real', 'J', 'F', '2023-07-22', NULL, 16, 16, 16, 16),
(17, 'Búfalo', 'A', 'M', '2014-04-18', NULL, 17, 17, 17, 17),
(18, 'Oso pardo', 'J', 'F', '2022-11-30', NULL, 18, 18, 18, 18),
(19, 'Gacela', 'A', 'F', '2019-01-11', NULL, 19, 19, 19, 19),
(20, 'Cheetah', 'J', 'M', '2023-05-07', NULL, 20, 20, 20, 20);
GO

-- Insertar datos en UBIGEO
INSERT INTO UBIGEO (Id_Ubigeo, IdDepa, IdProv, IdDis, Departamento, Provincia, Distrito)
VALUES 
('150101', '01', '01', '01', 'Lima', 'Lima', 'Lima'),
('150102', '01', '01', '02', 'Lima', 'Lima', 'Miraflores'),
('150103', '01', '01', '03', 'Lima', 'Lima', 'San Isidro'),
('020101', '02', '01', '01', 'Arequipa', 'Arequipa', 'Arequipa'),
('020102', '02', '01', '02', 'Arequipa', 'Arequipa', 'Cayma'),
('020103', '02', '02', '01', 'Cusco', 'Cusco', 'Cusco'),
('020104', '02', '02', '02', 'Cusco', 'Cusco', 'San Sebastián'),
('150104', '01', '02', '01', 'Lima', 'Callao', 'Callao'),
('150105', '01', '02', '02', 'Lima', 'Callao', 'Bellavista'),
('150106', '01', '03', '01', 'Lima', 'Lima', 'Surco'),
('150107', '01', '03', '02', 'Lima', 'Lima', 'Barranco'),
('150108', '01', '04', '01', 'Lima', 'Lima', 'Pueblo Libre'),
('150109', '01', '04', '02', 'Lima', 'Lima', 'San Borja'),
('150110', '01', '05', '01', 'Lima', 'Lima', 'Rimac'),
('150111', '01', '05', '02', 'Lima', 'Lima', 'Lince'),
('150112', '01', '06', '01', 'Lima', 'Lima', 'Jesús María'),
('150113', '01', '06', '02', 'Lima', 'Lima', 'La Molina'),
('150114', '01', '07', '01', 'Lima', 'Lima', 'San Martín de Porres'),
('150115', '01', '07', '02', 'Lima', 'Lima', 'El Agustino'),
('150116', '01', '08', '01', 'Lima', 'Lima', 'San Juan de Lurigancho');
GO

-- Insertar datos en VETERINARIO
INSERT INTO VETERINARIO (IdVet, ApeVet, NomVet, EspecVet, Direccion, Email, Id_Ubigeo, FechaIngreso, Estado)
VALUES 
(1, 'Pérez', 'Carlos', 'A', 'Av. Los Olivos 123', 'cperez@mail.com', '150101', '2022-01-15', 1),
(2, 'González', 'Ana', 'B', 'Calle Fresa 456', 'agonzalez@mail.com', '150102', '2021-05-20', 1),
(3, 'Rodríguez', 'Luis', 'A', 'Av. Santa Rosa 789', 'lrodriguez@mail.com', '150103', '2020-07-12', 1),
(4, 'Martínez', 'Sofía', 'C', 'Calle La Paz 321', 'smartinez@mail.com', '020101', '2021-02-05', 1),
(5, 'García', 'Juan', 'B', 'Av. Colón 654', 'jgarcia@mail.com', '020102', '2021-11-18', 1),
(6, 'Fernández', 'Marta', 'A', 'Calle Miraflores 987', 'mfernandez@mail.com', '020103', '2020-09-10', 1),
(7, 'López', 'Ricardo', 'C', 'Av. La Marina 123', 'rlopez@mail.com', '150104', '2022-03-22', 1),
(8, 'Hernández', 'Laura', 'B', 'Calle Abancay 456', 'lhernandez@mail.com', '150105', '2021-06-13', 1),
(9, 'Díaz', 'José', 'A', 'Av. Pescadores 789', 'jdiaz@mail.com', '150106', '2021-12-01', 1),
(10, 'Martín', 'Patricia', 'C', 'Calle Lima 111', 'pmartin@mail.com', '150107', '2020-08-05', 1),
(11, 'Álvarez', 'Pedro', 'A', 'Calle San Juan 222', 'palvarez@mail.com', '150108', '2022-04-25', 1),
(12, 'Gómez', 'Carla', 'B', 'Av. El Sol 333', 'cgomez@mail.com', '150109', '2021-10-15', 1),
(13, 'Sánchez', 'Miguel', 'A', 'Calle La Libertad 444', 'msanchez@mail.com', '150110', '2020-12-20', 1),
(14, 'Paredes', 'Elena', 'C', 'Calle Santa Teresa 555', 'eparedes@mail.com', '150111', '2022-07-10', 1),
(15, 'Cruz', 'David', 'B', 'Av. José Olaya 666', 'dcruz@mail.com', '150112', '2021-09-03', 1),
(16, 'Vásquez', 'Raquel', 'A', 'Calle Francisco Bolognesi 777', 'rvasquez@mail.com', '150113', '2020-06-22', 1),
(17, 'Mendoza', 'Luis', 'C', 'Av. Benavides 888', 'lmendoza@mail.com', '150114', '2021-04-19', 1),
(18, 'Bravo', 'Sara', 'A', 'Calle Zorritos 999', 'sbravo@mail.com', '150115', '2022-01-10', 1),
(19, 'Vega', 'Tomás', 'B', 'Av. Huancayo 101', 'tvega@mail.com', '150116', '2021-02-28', 1),
(20, 'Salazar', 'Verónica', 'A', 'Calle Los Olivos 202', 'vsalazar@mail.com', '150101', '2020-11-11', 1);
GO

-- Insertar datos en ANIMAL_VETERINARIO
INSERT INTO ANIMAL_VETERINARIO (CodAnimal, IdVet, MedAdm, TiemAten)
VALUES 
(1, 1, 'Vacuna Antirrábica', 'D'),
(2, 1, 'Revisión General', 'S'),
(3, 2, 'Desparacitación', 'D'),
(4, 2, 'Revisión General', 'S'),
(5, 3, 'Vacuna Antirrábica', 'S'),
(6, 3, 'Revisión General', 'D'),
(7, 4, 'Desparacitación', 'D'),
(8, 4, 'Vacuna Antirrábica', 'S'),
(9, 5, 'Revisión General', 'D'),
(10, 5, 'Desparacitación', 'S'),
(11, 6, 'Vacuna Antirrábica', 'D'),
(12, 6, 'Revisión General', 'S'),
(13, 7, 'Desparacitación', 'D'),
(14, 7, 'Revisión General', 'S'),
(15, 8, 'Vacuna Antirrábica', 'D'),
(16, 8, 'Revisión General', 'S'),
(17, 9, 'Desparacitación', 'D'),
(18, 9, 'Revisión General', 'S'),
(19, 10, 'Vacuna Antirrábica', 'D'),
(20, 10, 'Revisión General', 'S');
GO

-- Insertar datos en PERSONAL
INSERT INTO PERSONAL (IdPer, PuestoPer, NomPer, ApePer, Direccion, FechaNacimiento, FechaIngreso, Estado, NumTelPer, CorrElecPer, Id_Ubigeo)
VALUES 
(1, 'A', 'Carlos', 'Pérez', 'Av. Los Olivos 123', '1990-05-15', '2020-01-10', 1, '987654321', 'cperez@mail.com', '150101'),
(2, 'B', 'Ana', 'González', 'Calle Fresa 456', '1985-03-10', '2019-02-22', 1, '988765432', 'agonzalez@mail.com', '150102'),
(3, 'A', 'Luis', 'Rodríguez', 'Av. Santa Rosa 789', '1992-07-25', '2018-03-12', 1, '999876543', 'lrodriguez@mail.com', '150103'),
(4, 'C', 'Sofía', 'Martínez', 'Calle La Paz 321', '1991-08-30', '2020-10-05', 1, '987123456', 'smartinez@mail.com', '020101'),
(5, 'B', 'Juan', 'García', 'Av. Colón 654', '1987-02-14', '2021-11-12', 1, '988234567', 'jgarcia@mail.com', '020102'),
(6, 'A', 'Marta', 'Fernández', 'Calle Miraflores 987', '1994-11-10', '2019-09-05', 1, '999543210', 'mfernandez@mail.com', '020103'),
(7, 'C', 'Ricardo', 'López', 'Av. La Marina 123', '1988-01-11', '2021-02-17', 1, '987654321', 'rlopez@mail.com', '150104'),
(8, 'B', 'Laura', 'Hernández', 'Calle Abancay 456', '1990-10-22', '2020-04-07', 1, '988765432', 'lhernandez@mail.com', '150105'),
(9, 'A', 'José', 'Díaz', 'Av. Pescadores 789', '1993-03-19', '2021-08-03', 1, '999876543', 'jdiaz@mail.com', '150106'),
(10, 'C', 'Patricia', 'Martín', 'Calle Lima 111', '1992-12-04', '2020-05-28', 1, '987123456', 'pmartin@mail.com', '150107'),
(11, 'A', 'Pedro', 'Álvarez', 'Calle San Juan 222', '1985-01-30', '2019-07-21', 1, '988234567', 'palvarez@mail.com', '150108'),
(12, 'B', 'Carla', 'Gómez', 'Av. El Sol 333', '1990-09-05', '2021-06-17', 1, '988123456', 'cgomez@mail.com', '150109'),
(13, 'A', 'Javier', 'López', 'Calle Zorritos 444', '1982-11-25', '2020-12-10', 1, '987543210', 'jlopez@mail.com', '150110'),
(14, 'C', 'Daniela', 'Morales', 'Calle San Martín 555', '1986-06-13', '2021-03-22', 1, '988543210', 'dmorales@mail.com', '150111'),
(15, 'B', 'Ricardo', 'Martínez', 'Av. Pedro Ruiz 666', '1993-01-17', '2020-02-07', 1, '987987987', 'rmartinez@mail.com', '150112'),
(16, 'A', 'Sofía', 'Hernández', 'Calle Las Palmas 777', '1994-04-20', '2021-11-23', 1, '988654321', 'shernandez@mail.com', '150113'),
(17, 'C', 'Fernando', 'Salazar', 'Calle La Victoria 888', '1989-08-12', '2020-06-29', 1, '999654321', 'fsalazar@mail.com', '150114'),
(18, 'B', 'Gabriela', 'Rojas', 'Av. Tacna 999', '1992-10-02', '2021-01-15', 1, '988765432', 'grojas@mail.com', '150115'),
(19, 'A', 'Tomás', 'Díaz', 'Calle Los Andes 100', '1987-02-18', '2020-03-18', 1, '987321654', 'tdiaz@mail.com', '150116'),
(20, 'C', 'Verónica', 'Vásquez', 'Av. Perú 101', '1990-06-14', '2020-07-20', 1, '988234567', 'vvasquez@mail.com', '150101');
GO

-- Insertar datos en ANIMAL_PERSONAL
INSERT INTO ANIMAL_PERSONAL (CodAnimal, IdPer, TiemCuid) 
VALUES 
(1, 1, '2 horas'),
(2, 2, '1 hora'),
(3, 3, '3 horas'),
(4, 4, '1.5 horas'),
(5, 5, '2 horas'),
(6, 6, '1 hora'),
(7, 7, '2.5 horas'),
(8, 8, '1 hora'),
(9, 9, '3 horas'),
(10, 10, '2 horas'),
(11, 11, '1 hora'),
(12, 12, '2.5 horas'),
(13, 13, '3 horas'),
(14, 14, '1 hora'),
(15, 15, '2 horas'),
(16, 16, '1.5 horas'),
(17, 17, '2 horas'),
(18, 18, '1 hora'),
(19, 19, '2.5 horas'),
(20, 20, '3 horas');
GO

-- Insertar datos en RECORRIDO
INSERT INTO RECORRIDO (NroReco, NomReco, DescReco, AniExhiRec) 
VALUES 
(1, 'Safari africano', 'Recorrido por la sabana africana', 20),
(2, 'Exploración en la selva', 'Aventura en la selva amazónica', 30),
(3, 'Visita al desierto', 'Descubre la vida en el desierto', 15),
(4, 'Tour por las montañas', 'Recorrido por las montañas rocosas', 25),
(5, 'Paseo por el bosque', 'Explora el bosque templado', 18),
(6, 'Tour por el pantano', 'Descubre el ecosistema del pantano', 12),
(7, 'Visita a las islas', 'Explora las islas Galápagos', 22),
(8, 'Tour por la tundra', 'Recorrido por la tundra ártica', 10),
(9, 'Exploración de praderas', 'Descubre las praderas de América del Norte', 28),
(10, 'Tour mediterráneo', 'Recorrido por la región mediterránea', 16),
(11, 'Visita al bosque boreal', 'Explora el bosque boreal', 14),
(12, 'Safari asiático', 'Aventura en la sabana asiática', 20),
(13, 'Recorrido por el bosque lluvioso', 'Descubre el bosque lluvioso tropical', 24),
(14, 'Exploración en el desierto de Gobi', 'Recorrido por el desierto de Gobi', 9),
(15, 'Tour por el Himalaya', 'Recorrido por las montañas del Himalaya', 11),
(16, 'Exploración en Borneo', 'Descubre la selva de Borneo', 19),
(17, 'Visita a la estepa siberiana', 'Recorrido por la estepa siberiana', 8),
(18, 'Tour por el bosque de coníferas', 'Explora el bosque de coníferas', 17),
(19, 'Visita a los manglares', 'Descubre los manglares costeros', 13),
(20, 'Tour de coral', 'Explora la reserva de coral', 21);
GO

-- Insertar datos en DETALLE_RECORRIDO
INSERT INTO DETALLE_RECORRIDO (CodAnimal, NroReco, CodHab) 
VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20);
GO

-- Insertar datos en VISITANTE
INSERT INTO VISITANTE (IdVisit, DirecVisit, NomVisit, ApeVisit, CorrElectVisit, Id_Ubigeo)
VALUES 
(1, 'Av. Los Álamos 123', 'Carlos', 'Pérez', 'cperez@mail.com', '150101'),
(2, 'Calle Los Andes 456', 'Ana', 'González', 'agonzalez@mail.com', '150102'),
(3, 'Av. Santa Cruz 789', 'Luis', 'Rodríguez', 'lrodriguez@mail.com', '150103'),
(4, 'Calle Lima 321', 'Sofía', 'Martínez', 'smartinez@mail.com', '020101'),
(5, 'Av. Colón 654', 'Juan', 'García', 'jgarcia@mail.com', '020102'),
(6, 'Calle Miraflores 987', 'Marta', 'Fernández', 'mfernandez@mail.com', '020103'),
(7, 'Av. La Marina 123', 'Ricardo', 'López', 'rlopez@mail.com', '150104'),
(8, 'Calle Abancay 456', 'Laura', 'Hernández', 'lhernandez@mail.com', '150105'),
(9, 'Av. Pescadores 789', 'José', 'Díaz', 'jdiaz@mail.com', '150106'),
(10, 'Calle San Juan 222', 'Patricia', 'Martín', 'pmartin@mail.com', '150107'),
(11, 'Calle El Sol 333', 'Pedro', 'Álvarez', 'palvarez@mail.com', '150108'),
(12, 'Calle Las Palmas 444', 'Carla', 'Gómez', 'cgomez@mail.com', '150109'),
(13, 'Calle Zorritos 555', 'Javier', 'López', 'jlopez@mail.com', '150110'),
(14, 'Calle San Martín 666', 'Daniela', 'Morales', 'dmorales@mail.com', '150111'),
(15, 'Calle Pedro Ruiz 777', 'Ricardo', 'Martínez', 'rmartinez@mail.com', '150112'),
(16, 'Calle Los Andes 888', 'Sofía', 'Hernández', 'shernandez@mail.com', '150113'),
(17, 'Av. El Sol 999', 'Fernando', 'Salazar', 'fsalazar@mail.com', '150114'),
(18, 'Calle Tacna 1000', 'Gabriela', 'Rojas', 'grojas@mail.com', '150115'),
(19, 'Av. Perú 101', 'Tomás', 'Díaz', 'tdiaz@mail.com', '150116'),
(20, 'Calle Lima 102', 'Verónica', 'Vásquez', 'vvasquez@mail.com', '150101');
GO


-- Insertar datos en ENTRADA
INSERT INTO ENTRADA (CodEntr, TipoEntr, FechaCom, HoraCom, PrecioEntr, NroReco, IdVisit, Id_Ubigeo)
VALUES 
(1, 'V', '2024-01-01', '10:00', 50.00, 1, 1, '150101'),
(2, 'G', '2024-01-02', '11:00', 30.00, 2, 2, '150102'),
(3, 'N', '2024-01-03', '12:00', 15.00, 3, 3, '150103'),
(4, 'V', '2024-01-04', '13:00', 50.00, 4, 4, '020101'),
(5, 'G', '2024-01-05', '14:00', 30.00, 5, 5, '020102'),
(6, 'N', '2024-01-06', '15:00', 15.00, 6, 6, '020103'),
(7, 'V', '2024-01-07', '16:00', 50.00, 7, 7, '020104'),
(8, 'G', '2024-01-08', '17:00', 30.00, 8, 8, '150104'),
(9, 'N', '2024-01-09', '18:00', 15.00, 9, 9, '150105'),
(10, 'V', '2024-01-10', '19:00', 50.00, 10, 10, '150106'),
(11, 'G', '2024-01-11', '20:00', 30.00, 11, 11, '150107'),
(12, 'N', '2024-01-12', '21:00', 15.00, 12, 12, '150108'),
(13, 'V', '2024-01-13', '10:00', 50.00, 13, 13, '150109'),
(14, 'G', '2024-01-14', '11:00', 30.00, 14, 14, '150110'),
(15, 'N', '2024-01-15', '12:00', 15.00, 15, 15, '150111'),
(16, 'V', '2024-01-16', '13:00', 50.00, 16, 16, '150112'),
(17, 'G', '2024-01-17', '14:00', 30.00, 17, 17, '150113'),
(18, 'N', '2024-01-18', '15:00', 15.00, 18, 18, '150114'),
(19, 'V', '2024-01-19', '16:00', 50.00, 19, 19, '150115'),
(20, 'G', '2024-01-20', '17:00', 30.00, 20, 20, '150116');
GO

--Procedimientos almacenados de la tabla HABITAT
--Procedimientos almacenados INSERT

CREATE PROCEDURE sp_InsertHabitat
    @CodHab INT,
    @DescHab VARCHAR(100),
    @NomHab VARCHAR(30),
    @AniHabi INT
AS
BEGIN
    INSERT INTO HABITAT (CodHab, DescHab, NomHab, AniHabi)
    VALUES (@CodHab, @DescHab, @NomHab, @AniHabi);
END;
GO
--Ejecutamos

EXEC sp_InsertHabitat 
    @CodHab = 21, 
    @DescHab = 'Bosque tropical', 
    @NomHab = 'Selva amazónica', 
    @AniHabi = 2024;
GO

EXEC sp_InsertHabitat 
    @CodHab = 22, 
    @DescHab = 'Desierto árido', 
    @NomHab = 'Sahara', 
    @AniHabi = 2023;
GO

SELECT * FROM HABITAT
GO

--Procedimiento almacenado UPDATE

CREATE PROCEDURE sp_UpdateHabitat
    @CodHab INT,
    @DescHab VARCHAR(100),
    @NomHab VARCHAR(30),
    @AniHabi INT
AS
BEGIN
    UPDATE HABITAT
    SET DescHab = @DescHab,
        NomHab = @NomHab,
        AniHabi = @AniHabi
    WHERE CodHab = @CodHab;
END;
GO

--Ejecutamos
EXEC sp_UpdateHabitat 
    @CodHab = 22, 
    @DescHab = 'Bosque subtropical', 
    @NomHab = 'Selva del Caribe', 
    @AniHabi = 202;
GO

--Procedimiento almacenado DELETE

CREATE PROCEDURE sp_DeleteHabitat
    @CodHab INT
AS
BEGIN
    DELETE FROM HABITAT
    WHERE CodHab = @CodHab;
END;
GO

--Ejecutamos
EXEC sp_DeleteHabitat 
    @CodHab = 22;
GO

--Procedimiento almacenado CONSULT 

CREATE OR ALTER PROCEDURE usp_ConsultarHabitat
    @CodHab INT
as
  BEGIN 
  SELECT 
       [CodHab]
      ,[DescHab]
      ,[NomHab]
      ,[AniHabi]
  FROM [dbo].[vw_Habitat]
  where CodHab = @CodHab

END

GO 
--Ejecutamos 
EXEC usp_ConsultarHabitat '5'
GO

--Procedimiento almacenado LIST

CREATE OR ALTER PROCEDURE sp_ListarHabitat
AS
BEGIN

SELECT [CodHab]
      ,[DescHab]
      ,[NomHab]
      ,[AniHabi]
  FROM [dbo].[vw_Habitat]
  ORDER BY CodHab -- Ejemplo de su  funcionamiento

END

GO

--Ejecutamos
EXEC sp_ListarHabitat;
GO

--Procedimiento transaccional

CREATE PROCEDURE sp_InsertHabitat_Transaccional
    @CodHab INT,
    @DescHab VARCHAR(100),
    @NomHab VARCHAR(30),
    @AniHabi INT
AS
BEGIN
    
    BEGIN TRANSACTION;

    BEGIN TRY
        
        INSERT INTO HABITAT (CodHab, DescHab, NomHab, AniHabi)
        VALUES (@CodHab, @DescHab, @NomHab, @AniHabi);

        
        COMMIT;
    END TRY
    BEGIN CATCH
        
        ROLLBACK;
        THROW;
    END CATCH;
END;
GO

--Ejecutamos

EXEC sp_InsertHabitat_Transaccional 
    @CodHab = 22, 
    @DescHab = 'Montaña nevada', 
    @NomHab = 'Andes', 
    @AniHabi = 2024;
GO


/*
-- Intentar insertar un hábitat con un código ya existente (esto debería provocar un error si el CodHab es clave primaria)
EXEC sp_InsertHabitat_Transaccional 
    @CodHab = 1, 
    @DescHab = 'Desierto de Atacama', 
    @NomHab = 'Atacama', 
    @AniHabi = 2024;
GO

-- Este bloque se dejó como prueba de error, pero se comenta para que el script completo corra sin detenerse.
*/
--Procedimientos almacenados de la tabla PERSONAL
--Procedimiento INSERT

 CREATE OR ALTER PROCEDURE sp_InsertarPersonal
    @PuestoPer CHAR(1),
    @NomPer VARCHAR(30),
    @ApePer VARCHAR(30),
    @Direccion VARCHAR(100),
    @FechaNacimiento DATE,
    @FechaIngreso DATE,
    @Foto IMAGE = NULL, 
    @Estado INT,
    @NumTelPer VARCHAR(9),
    @CorrElecPer VARCHAR(50),
    @Id_Ubigeo CHAR(6),
    @Usu_Registro VARCHAR(20)
AS
BEGIN
    DECLARE @NuevoId INT;
    SET @NuevoId = ISNULL((SELECT MAX(IdPer) FROM Personal), 0) + 1;

    INSERT INTO Personal
    (
        IdPer, PuestoPer, NomPer, ApePer, Direccion, FechaNacimiento,
        FechaIngreso, Foto, Estado, NumTelPer, CorrElecPer, Id_Ubigeo
    )
    VALUES
    (
        @NuevoId, @PuestoPer, @NomPer, @ApePer, @Direccion, @FechaNacimiento,
        @FechaIngreso, @Foto, @Estado, @NumTelPer, @CorrElecPer, @Id_Ubigeo
    );
END
GO

--Ejecutamos
EXEC sp_InsertarPersonal
    @PuestoPer = 'A',
    @NomPer = 'Marcos',
    @ApePer = 'Ramirez',
    @Direccion = 'Av. Brasil 625',
    @FechaNacimiento = '1982-08-13',
    @FechaIngreso = '2021-04-18',
    @Foto = NULL, 
    @Estado = 1,
    @NumTelPer = '981598623',
    @CorrElecPer = 'marcos.ramirez@gmail.com',
    @Id_Ubigeo = '150101',
    @Usu_Registro = 'admin';

SELECT * FROM PERSONAL
GO

--Procedimiento UPDATE
CREATE OR ALTER PROCEDURE sp_ActualizarPersonal
    @IdPer INT,
    @PuestoPer CHAR(1),
    @NomPer VARCHAR(30),
    @ApePer VARCHAR(30),
    @Direccion VARCHAR(100),
    @FechaNacimiento DATE,
    @FechaIngreso DATE,
    @Foto IMAGE = NULL, 
    @Estado INT,
    @NumTelPer VARCHAR(9),
    @CorrElecPer VARCHAR(50),
    @Id_Ubigeo CHAR(6),
    @UsuUltMod VARCHAR(20)
AS
BEGIN
    
    UPDATE Personal
    SET
        PuestoPer = @PuestoPer,
        NomPer = @NomPer,
        ApePer = @ApePer,
        Direccion = @Direccion,
        FechaNacimiento = @FechaNacimiento,
        FechaIngreso = @FechaIngreso,
        Foto = @Foto,
        Estado = @Estado,
        NumTelPer = @NumTelPer,
        CorrElecPer = @CorrElecPer,
        Id_Ubigeo = @Id_Ubigeo
    WHERE IdPer = @IdPer;
END
GO

--Ejecutamos 
EXEC sp_ActualizarPersonal
    @IdPer = 21,
    @PuestoPer = 'B',
    @NomPer = 'Marcos',
    @ApePer = 'Gómez',
    @Direccion = 'Av. Mexico 512',
    @FechaNacimiento = '1982-08-13',
    @FechaIngreso = '2021-04-18',
    @Foto = NULL,
    @Estado = 1,
    @NumTelPer = '910852693',
    @CorrElecPer = 'carlos.gomez@gmail.com',
    @Id_Ubigeo = '150102',
    @UsuUltMod = 'admin';
GO

--Procedimiento DELETE
CREATE OR ALTER PROCEDURE sp_EliminarPersonal
    @IdPer INT
AS
BEGIN
    
    DELETE FROM ANIMAL_PERSONAL 
    WHERE IdPer = @IdPer;

    
    DELETE FROM PERSONAL 
    WHERE IdPer = @IdPer;
END
GO

--Ejecutamos 

EXEC sp_EliminarPersonal @IdPer = 22;  
GO

--Procedimiento CONSULT 
CREATE OR ALTER PROCEDURE sp_ConsultarPersonal
    @IdPer INT
AS
BEGIN

SELECT [IdPer]
      ,[PuestoPer]
      ,[NomPer]
      ,[ApePer]
      ,[Direccion]
      ,[FechaNacimiento]
      ,[FechaIngreso]
      ,[NumTelPer]
      ,[CorrElecPer]
      ,[Departamento]
      ,[Provincia]
      ,[Distrito]
      ,[EstadoPersonal]
  FROM [dbo].[vw_PersonalInfo]
  WHERE IdPer = @IdPer

END
GO

--Ejecutamos
EXEC sp_ConsultarPersonal @IdPer = 10;
GO


--Procedimiento listar 

CREATE OR ALTER PROCEDURE sp_ListarPersonal
AS
BEGIN
SELECT [IdPer]
      ,[PuestoPer]
      ,[NomPer]
      ,[ApePer]
      ,[Direccion]
      ,[FechaNacimiento]
      ,[FechaIngreso]
      ,[NumTelPer]
      ,[CorrElecPer]
      ,[Departamento]
      ,[Provincia]
      ,[Distrito]
      ,[EstadoPersonal]
  FROM [dbo].[vw_PersonalInfo]
  ORDER BY IdPer

END
GO

--Ejecutamos
EXEC sp_ListarPersonal;
GO


--Procedimiento transaccional 

CREATE OR ALTER PROCEDURE sp_InsertarPersonalTransaccional
    @PuestoPer CHAR(1),
    @NomPer VARCHAR(30),
    @ApePer VARCHAR(30),
    @Direccion VARCHAR(100),
    @FechaNacimiento DATE,
    @FechaIngreso DATE,
    @Foto IMAGE = NULL,
    @Estado INT,
    @NumTelPer VARCHAR(9),
    @CorrElecPer VARCHAR(50),
    @Id_Ubigeo CHAR(6),
    @Usu_Registro VARCHAR(20),
    @CodAnimal INT,
    @TiemCuid VARCHAR(10)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
       
        DECLARE @NuevoId INT;
        SET @NuevoId = ISNULL((SELECT MAX(IdPer) FROM Personal), 0) + 1;

        INSERT INTO Personal
        (
            IdPer, PuestoPer, NomPer, ApePer, Direccion, FechaNacimiento,
            FechaIngreso, Foto, Estado, NumTelPer, CorrElecPer, Id_Ubigeo
        )
        VALUES
        (
            @NuevoId, @PuestoPer, @NomPer, @ApePer, @Direccion, @FechaNacimiento,
            @FechaIngreso, @Foto, @Estado, @NumTelPer, @CorrElecPer, @Id_Ubigeo
        );
        INSERT INTO ANIMAL_PERSONAL
        (
            CodAnimal, IdPer, TiemCuid
        )
        VALUES
        (
            @CodAnimal, @NuevoId, @TiemCuid
        );  
        COMMIT TRANSACTION;
        PRINT 'Inserción completada.';
    END TRY
    BEGIN CATCH
       
        ROLLBACK TRANSACTION;
        PRINT 'Ocurrió un error.';
        THROW; 
    END CATCH
END
GO

--Ejecutamos

EXEC sp_InsertarPersonalTransaccional
    @PuestoPer = 'A',
    @NomPer = 'Carla',
    @ApePer = 'Serna',
    @Direccion = 'Av. Villa Universitaria',
    @FechaNacimiento = '1864-09-22',
    @FechaIngreso = '2021-12-23',
    @Foto = NULL,
    @Estado = 1,
    @NumTelPer = '956986132',
    @CorrElecPer = 'carla.cerna@gmail.com',
    @Id_Ubigeo = '150103',
    @Usu_Registro = 'admin',
    @CodAnimal = 20, 
    @TiemCuid = '3.5 horas';
GO


EXEC sp_ListarPersonal;

GO
SELECT * FROM ANIMAL_PERSONAL;
GO


--Procedimientos almacenados de la tabla ESPECIE

--Procedimiento Insert

CREATE OR ALTER PROCEDURE sp_InsertEspecie
    @CodEspe INT,
    @NomEspe VARCHAR(30),
    @DescEspe VARCHAR(100),
    @CodHabitat INT
AS
BEGIN
    INSERT INTO ESPECIE (CodEspe, NomEspe, DescEspe, CodHabitat)
    VALUES (@CodEspe, @NomEspe, @DescEspe, @CodHabitat);
END;
GO


--Ejecutamos
EXEC sp_InsertEspecie 
    @CodEspe = 21,
    @NomEspe = 'Lemur', 
    @DescEspe = 'Mamífero endémico de Madagascar', 
    @CodHabitat = 4;
GO

--Procedimiento UPDATE

CREATE OR ALTER PROCEDURE sp_UpdateEspecie
    @CodEspe INT,
    @NomEspe VARCHAR(30),
    @DescEspe VARCHAR(100),
    @CodHabitat INT
AS
BEGIN
    UPDATE ESPECIE
    SET NomEspe = @NomEspe,
        DescEspe = @DescEspe,
        CodHabitat = @CodHabitat
    WHERE CodEspe = @CodEspe;
END;
GO

--Ejecutamos

EXEC sp_UpdateEspecie 
    @CodEspe = 21, 
    @NomEspe = 'Lemur', 
    @DescEspe = 'Mamífero endémico de Madagascar', 
    @CodHabitat = 6;
GO

SELECT * FROM ESPECIE
GO


--Procedimiento DELETE

CREATE OR ALTER PROCEDURE sp_DeleteEspecie
    @CodEspe INT
AS
BEGIN
    DELETE FROM ESPECIE
    WHERE CodEspe = @CodEspe;
END;
GO

--Ejecutamos

EXEC sp_DeleteEspecie @CodEspe = 21;
GO

--Procedimiento CONSULT
CREATE OR ALTER PROCEDURE sp_ConsultarEspecie
@CodEspe INT
AS 
BEGIN
SELECT [CodEspe]
      ,[NomEspe]
      ,[DescEspe]
      ,[NomHab]
      ,[DescHab]
  FROM [dbo].[vw_EspeciesInfo]
  WHERE CodEspe = @CodEspe

END
GO

--Ejecutamos
EXEC sp_ConsultarEspecie '5'
GO

--Procedimiento LIST

CREATE OR ALTER PROCEDURE sp_ListarEspecies
AS
BEGIN

SELECT [CodEspe]
      ,[NomEspe]
      ,[DescEspe]
      ,[NomHab]
      ,[DescHab]
  FROM [dbo].[vw_EspeciesInfo]

END;
GO

--Ejecutamos
EXEC sp_ListarEspecies;
GO

--´Procedimiento Transaccional 

CREATE PROCEDURE sp_InsertEspecie_Transaccional
    @Operacion CHAR(1), -- 'I': Insertar, 'U': Actualizar, 'D': Eliminar
    @CodEspe INT = NULL,
    @NomEspe VARCHAR(30) = NULL,
    @DescEspe VARCHAR(100) = NULL,
    @CodHabitat INT = NULL
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF @Operacion = 'I'
        BEGIN
            INSERT INTO ESPECIE (NomEspe, DescEspe, CodHabitat)
            VALUES (@NomEspe, @DescEspe, @CodHabitat);
        END
        ELSE IF @Operacion = 'U'
        BEGIN
            UPDATE ESPECIE
            SET NomEspe = @NomEspe,
                DescEspe = @DescEspe,
                CodHabitat = @CodHabitat
            WHERE CodEspe = @CodEspe;
        END
        ELSE IF @Operacion = 'D'
        BEGIN
            DELETE FROM ESPECIE
            WHERE CodEspe = @CodEspe;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

--Ejecutamos
EXEC sp_InsertEspecie_Transaccional 
    @Operacion = 'U', 
    @CodEspe = 1, 
    @NomEspe = 'León Africano', 
    @DescEspe = 'Felino de gran tamaño que vive en África', 
    @CodHabitat = 1;
GO

--Procedimientos almacenados de la tabla de VETERINARIO
--PROCEDIMIENTO ALMACENADO INSERT
CREATE OR ALTER PROCEDURE usp_InsertVeterinario
    @IdVet INT,
    @ApeVet VARCHAR(30),
    @NomVet VARCHAR(30),
    @EspecVet CHAR(1),
    @Direccion VARCHAR(100),
    @Email VARCHAR(50),
    @Id_Ubigeo CHAR(6),
    @Foto IMAGE,
    @FechaIngreso DATE,
    @Estado INT
AS
BEGIN
    INSERT INTO VETERINARIO (IdVet, ApeVet, NomVet, EspecVet, Direccion, Email, Id_Ubigeo, Foto, FechaIngreso, Estado)
    VALUES (@IdVet, @ApeVet, @NomVet, @EspecVet, @Direccion, @Email, @Id_Ubigeo, @Foto, @FechaIngreso, @Estado);
END
GO

--EJECUTAMOS--
EXEC usp_InsertVeterinario
    @IdVet = 21,
    @ApeVet = 'Torres',
    @NomVet = 'Fernando',
    @EspecVet = 'A',
    @Direccion = 'Calle Primavera 123',
    @Email = 'ftorres@mail.com',
    @Id_Ubigeo = '150101',
    @Foto = NULL,
    @FechaIngreso = '2023-12-01',
    @Estado = 1;
go

SELECT * FROM VETERINARIO
GO

--PROCEDIMIENTO ALMACENADO UPDATE

CREATE OR ALTER PROCEDURE usp_UpdateVeterinario
    @IdVet INT,
    @ApeVet VARCHAR(30),
    @NomVet VARCHAR(30),
    @EspecVet CHAR(1),
    @Direccion VARCHAR(100),
    @Email VARCHAR(50),
    @Id_Ubigeo CHAR(6),
    @Foto IMAGE,
    @FechaIngreso DATE,
    @Estado INT
AS
BEGIN
    UPDATE VETERINARIO
    SET ApeVet = @ApeVet,
        NomVet = @NomVet,
        EspecVet = @EspecVet,
        Direccion = @Direccion,
        Email = @Email,
        Id_Ubigeo = @Id_Ubigeo,
        Foto = @Foto,
        FechaIngreso = @FechaIngreso,
        Estado = @Estado
    WHERE IdVet = @IdVet;
END;
GO

-- EJECUCION
EXEC usp_UpdateVeterinario
    @IdVet = 21,
    @ApeVet = 'Torres',
    @NomVet = 'Fernando',
    @EspecVet = 'A',
    @Direccion = 'Calle Nueva 456',
    @Email = 'ftorres@mail.com',
    @Id_Ubigeo = '150101',
    @Foto = NULL,
    @FechaIngreso = '2023-12-01',
    @Estado = 1;
go

SELECT * FROM VETERINARIO
GO

--PROCEDIMIENTO DELETE

CREATE OR ALTER PROCEDURE usp_DeleteVeterinario
    @IdVet INT
AS
BEGIN
    DELETE FROM VETERINARIO WHERE IdVet = @IdVet;
END;
GO

-- Ejemplo de Ejecución
EXEC usp_DeleteVeterinario
@IdVet = 21;
go

--PROCEDIMIENTO CONSULT
CREATE OR ALTER PROCEDURE sp_ConsultarVeterinarios
	@IdVet INT
as 
BEGIN 
SELECT [IdVet]
      ,[NomVet]
      ,[ApeVet]
      ,[EspecVet]
      ,[Direccion]
      ,[Email]
      ,[Departamento]
      ,[Provincia]
      ,[Distrito]
      ,[FechaIngreso]
      ,[Estado]
      ,[EstadoVeterinario]
  FROM [dbo].[vw_VeterinariosInfo]
  where IdVet = @IdVet
 
 END
 GO

 --Ejecutamos 
 EXEC sp_ConsultarVeterinarios @IdVet = 2;
GO

--PROCEDIMIENTO LIST--

CREATE or ALTER PROCEDURE sp_ListarVeterinarios
AS
BEGIN
SELECT [IdVet]
      ,[NomVet]
      ,[ApeVet]
      ,[EspecVet]
      ,[Direccion]
      ,[Email]
      ,[Departamento]
      ,[Provincia]
      ,[Distrito]
      ,[FechaIngreso]
      ,[Estado]
      ,[EstadoVeterinario]
  FROM [dbo].[vw_VeterinariosInfo]

END;
GO
--EJECUTAMOS--

EXEC sp_ListarVeterinarios;
GO

-- PROCEDIMIENTO TRANSACCIONAL--
CREATE PROCEDURE sp_insert_TransaccionVeterinario
    @IdVet INT,
    @ApeVet VARCHAR(30),
    @NomVet VARCHAR(30),
    @EspecVet CHAR(1),
    @Direccion VARCHAR(100),
    @Email VARCHAR(50),
    @Id_Ubigeo CHAR(6),
    @Foto IMAGE,
    @FechaIngreso DATE,
    @Estado INT,
    @IdVetActualizar INT,
    @NuevoEstado INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        EXEC usp_InsertVeterinario @IdVet, @ApeVet, @NomVet, @EspecVet, @Direccion, @Email, @Id_Ubigeo, @Foto, @FechaIngreso, @Estado;

        UPDATE VETERINARIO SET Estado = @NuevoEstado WHERE IdVet = @IdVetActualizar;

        COMMIT TRANSACTION;
        PRINT 'Inserción completada.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Ocurrió un error.';
        THROW; 
    END CATCH
END;
GO


--EJECUTAMOS--
EXEC sp_insert_TransaccionVeterinario
    @IdVet = 22,
    @ApeVet = 'Lopez',
    @NomVet = 'Patricia',
    @EspecVet = 'B',
    @Direccion = 'Calle Libertad 789',
    @Email = 'plopez@mail.com',
    @Id_Ubigeo = '150102',
    @Foto = NULL,
    @FechaIngreso = '2023-12-01',
    @Estado = 1,
    @IdVetActualizar = 1, 
    @NuevoEstado = 2;
GO


--Consultas Paginadas
--Consulta para Habitat
CREATE OR ALTER PROCEDURE PaginarHabitat
    @Pagina INT,
    @TamanoPagina INT,
    @Criterio1 NVARCHAR(100), -- NomHab
    @Criterio2 INT            -- AniHabi
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT CodHab, DescHab, NomHab, AniHabi
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY CodHab) AS Fila, CodHab, DescHab, NomHab, AniHabi
        FROM HABITAT
        WHERE NomHab LIKE '%' + @Criterio1 + '%'
          AND AniHabi = @Criterio2
    ) AS Resultado
    WHERE Fila BETWEEN (@Pagina - 1) * @TamanoPagina + 1 AND @Pagina * @TamanoPagina;
END;

GO

--ejecucion
EXEC PaginarHabitat @Pagina = 1, @TamanoPagina = 5, @Criterio1 = 'Selva', @Criterio2 = 20;
GO
--Consulta para Especie
CREATE OR ALTER PROCEDURE PaginarEspecie
    @Pagina INT,
    @TamanoPagina INT,
    @Criterio1 NVARCHAR(100), -- NomEspe
    @Criterio2 INT            -- CodHabitat
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT CodEspe, NomEspe, DescEspe, CodHabitat
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY CodEspe) AS Fila, CodEspe, NomEspe, DescEspe, CodHabitat
        FROM ESPECIE
        WHERE NomEspe LIKE '%' + @Criterio1 + '%'
          AND CodHabitat = @Criterio2
    ) AS Resultado
    WHERE Fila BETWEEN (@Pagina - 1) * @TamanoPagina + 1 AND @Pagina * @TamanoPagina;
END;

GO

--ejecutamos
EXEC PaginarEspecie @Pagina = 1, @TamanoPagina = 5, @Criterio1 = 'Tigre', @Criterio2 = '2';
GO
--Consulta para Alimento
CREATE OR ALTER PROCEDURE PaginarAlimento
    @Pagina INT,
    @TamanoPagina INT,
    @Criterio1 NVARCHAR(100), -- TipoAlim
    @Criterio2 NVARCHAR(100)  -- FrecAlim
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT CodAlim, TipoAlim, CantAlim, FrecAlim
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY CodAlim) AS Fila, CodAlim, TipoAlim, CantAlim, FrecAlim
        FROM ALIMENTO
        WHERE TipoAlim LIKE '%' + @Criterio1 + '%'
          AND FrecAlim LIKE '%' + @Criterio2 + '%'
    ) AS Resultado
    WHERE Fila BETWEEN (@Pagina - 1) * @TamanoPagina + 1 AND @Pagina * @TamanoPagina;
END;

GO

--ejecutamos
EXEC PaginarAlimento @Pagina = 1, @TamanoPagina = 5, @Criterio1 = 'C', @Criterio2 = 'M';
GO
--Consulta para Animal
CREATE OR ALTER PROCEDURE PaginarAnimal
    @Pagina INT,
    @TamanoPagina INT,
    @Criterio1 NVARCHAR(100), -- NomAnimal
    @Criterio2 NVARCHAR(100)  -- GenAnimal
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT CodAnimal, NomAnimal, EdAnimal, GenAnimal, FechaNacimiento, Foto, Estado, CodEspe, CodAlim, CodHab
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY CodAnimal) AS Fila, CodAnimal, NomAnimal, EdAnimal, GenAnimal, FechaNacimiento, Foto, Estado, CodEspe, CodAlim, CodHab
        FROM ANIMAL
        WHERE NomAnimal LIKE '%' + @Criterio1 + '%'
          AND GenAnimal LIKE '%' + @Criterio2 + '%'
    ) AS Resultado
    WHERE Fila BETWEEN (@Pagina - 1) * @TamanoPagina + 1 AND @Pagina * @TamanoPagina;
END;

GO

--ejecutamos
EXEC PaginarAnimal @Pagina = 1, @TamanoPagina = 5, @Criterio1 = 'Jaguar', @Criterio2 = 'M';
GO
--Consulta para Ubigeo
CREATE OR ALTER PROCEDURE PaginarUbigeo
    @Pagina INT,
    @TamanoPagina INT,
    @Criterio1 NVARCHAR(100), -- Departamento
    @Criterio2 NVARCHAR(100)  -- Provincia
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT Id_Ubigeo, IdDepa, IdProv, IdDis, Departamento, Provincia, Distrito
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY Id_Ubigeo) AS Fila, Id_Ubigeo, IdDepa, IdProv, IdDis, Departamento, Provincia, Distrito
        FROM UBIGEO
        WHERE Departamento LIKE '%' + @Criterio1 + '%'
          AND Provincia LIKE '%' + @Criterio2 + '%'
    ) AS Resultado
    WHERE Fila BETWEEN (@Pagina - 1) * @TamanoPagina + 1 AND @Pagina * @TamanoPagina;
END;

GO

--ejecutamos
EXEC PaginarUbigeo @Pagina = 1, @TamanoPagina = 5, @Criterio1 = 'Lima', @Criterio2 = 'Lima';
GO
--Consulta para Veterinario
CREATE OR ALTER PROCEDURE PaginarVeterinario
    @Pagina INT,
    @TamanoPagina INT,
    @Criterio1 NVARCHAR(100), -- NomVet
    @Criterio2 NVARCHAR(100)  -- EspecVet
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT IdVet, ApeVet, NomVet, EspecVet, Direccion, Email, Id_Ubigeo, Foto, FechaIngreso, Estado
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY IdVet) AS Fila, IdVet, ApeVet, NomVet, EspecVet, Direccion, Email, Id_Ubigeo, Foto, FechaIngreso, Estado
        FROM VETERINARIO
        WHERE NomVet LIKE '%' + @Criterio1 + '%'
          AND EspecVet LIKE '%' + @Criterio2 + '%'
    ) AS Resultado
    WHERE Fila BETWEEN (@Pagina - 1) * @TamanoPagina + 1 AND @Pagina * @TamanoPagina;
END;

GO

--ejecutamos
EXEC PaginarVeterinario @Pagina = 1, @TamanoPagina = 5, @Criterio1 = 'Ana', @Criterio2 = 'B';
GO
--Consulta para Animal_Veterinario
CREATE OR ALTER PROCEDURE PaginarAnimalVeterinario
    @Pagina INT,
    @TamanoPagina INT,
    @Criterio1 INT, -- CodAnimal
    @Criterio2 INT  -- IdVet
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT CodAnimal, IdVet, MedAdm, TiemAten
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY CodAnimal) AS Fila, CodAnimal, IdVet, MedAdm, TiemAten
        FROM ANIMAL_VETERINARIO
        WHERE CodAnimal = @Criterio1
          AND IdVet = @Criterio2
    ) AS Resultado
    WHERE Fila BETWEEN (@Pagina - 1) * @TamanoPagina + 1 AND @Pagina * @TamanoPagina;
END;

GO

--Ejecutamos
EXEC PaginarAnimalVeterinario @Pagina = 1, @TamanoPagina = 5, @Criterio1 = '1', @Criterio2 = '1';
GO