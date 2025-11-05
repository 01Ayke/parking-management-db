-- ============================================================
--   Nom de la base   :  PARKING                                
-- ============================================================

-- ============================================================
--   Table : Véhicule                                            
-- ============================================================
CREATE TABLE vehicule (
    num_immatriculation SERIAL PRIMARY KEY,
    marque VARCHAR(255),
    date_de_fabrication DATE,
    etat VARCHAR(255),
    kilometrage INTEGER
);

-- ============================================================
--   Table : Place                                            
-- ============================================================
CREATE TABLE place (
    id_place SERIAL PRIMARY KEY,
    etat VARCHAR(255),
    id_parking INTEGER REFERENCES parking(id_parking)
);

-- ============================================================
--   Table : Créneau                                            
-- ============================================================
CREATE TABLE creneau
(
    id_creneau SERIAL PRIMARY KEY,
    date_creneau DATE,
    heure_debut VARCHAR(255),
    heure_fin VARCHAR(255)
    id_vehicule INTEGER REFERENCES vehicule(num_immatriculation),
    id_place INTEGER REFERENCES place(id_place),
);

-- ============================================================
--   Table : Commune                                            
-- ============================================================
CREATE TABLE commune
(
    id_commune SERIAL PRIMARY KEY,
    code_postal INTEGER,
    nom_commune VARCHAR(255),
);

-- ============================================================
--   Table : Parking                                            
-- ============================================================
CREATE TABLE parking (
    id_parking SERIAL PRIMARY KEY,
    nom VARCHAR(255),
    type_parking VARCHAR(255),
    adresse VARCHAR(255),
    capacite INTEGER,
    id_commune INTEGER REFERENCES commune(id_commune)
);

-- ============================================================
--   Table : Tarif                                            
-- ============================================================
CREATE TABLE tarif (
    id_tarif SERIAL PRIMARY KEY,
    prix FLOAT,
    date DATE
);

-- ============================================================
--   Table : Appliquer                                            
-- ============================================================
CREATE TABLE appliquer (
    id_parking INTEGER REFERENCES parking(id_parking),
    id_tarif INTEGER REFERENCES tarif(id_tarif),
    PRIMARY KEY (id_parking, id_tarif)
);