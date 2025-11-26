-- ============================================================
--   Nom de la base   :  PARKING                                
-- ============================================================

-- ============================================================
--   Table : Véhicule                                            
-- ============================================================
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    num_immatriculation VARCHAR(255), 
    marque VARCHAR(255),
    date_de_fabrication DATE,
    etat_vehicule VARCHAR(255),
    kilometrage INTEGER
);

-- ============================================================
--   Table : Place                                            
-- ============================================================
CREATE TABLE place (
    id_place SERIAL PRIMARY KEY,
    num_place VARCHAR(255),
    etat_place VARCHAR(255),
    CONSTRAINT fk_place_parking FOREIGN KEY(id_parking) REFERENCES parking(id_parking)
);

-- ============================================================
--   Table : Créneau                                            
-- ============================================================
CREATE TABLE creneau
(
    id_creneau SERIAL PRIMARY KEY,
    date_debut DATE,
    date_fin DATE,
    heure_debut VARCHAR(255),
    heure_fin VARCHAR(255),
    mode_paiement VARCHAR(255),
    CONSTRAINT fk_creneau_vehicule FOREIGN KEY(id_vehicule) REFERENCES vehicule(id_vehicule),
    CONSTRAINT fk_creneau_place FOREIGN KEY(id_place) REFERENCES place(id_place)
);

-- ============================================================
--   Table : Commune                                            
-- ============================================================
CREATE TABLE commune
(
    id_commune SERIAL PRIMARY KEY,
    code_postal INTEGER,
    nom_commune VARCHAR(255)
);

-- ============================================================
--   Table : Parking                                            
-- ============================================================
CREATE TABLE parking (
    id_parking SERIAL PRIMARY KEY,
    nom_parking VARCHAR(255),
    type_parking VARCHAR(255),
    adresse VARCHAR(255),
    capacite INTEGER,
    CONSTRAINT fk_parking_commune FOREIGN KEY(id_commune) REFERENCES commune(id_commune)
);

-- ============================================================
--   Table : Tarif                                            
-- ============================================================
CREATE TABLE tarif (
    id_tarif SERIAL PRIMARY KEY,
    prix FLOAT,
    type_jour VARCHAR(255),
    heure_debut_tarif VARCHAR(255),
    heure_fin_tarif VARCHAR(255),
    date_debut_tarif DATE,
    date_fin_tarif DATE
);

-- ============================================================
--   Table : Appliquer                                            
-- ============================================================
CREATE TABLE appliquer (
    id_parking INTEGER REFERENCES parking(id_parking),
    id_tarif INTEGER REFERENCES tarif(id_tarif),
    PRIMARY KEY (id_parking, id_tarif)
);

-- ============================================================
--   Table : Abonnement                                            
-- ============================================================
CREATE TABLE Abonnement (
    id_abonnement SERIAL PRIMARY KEY,
    date_debut_abonnement DATE,
    date_fin_abonnement DATE,
    type_abonnement VARCHAR(255),
    tarif_mensuel_abonnement FLOAT,
    CONSTRAINT fk_abonnement_vehicule FOREIGN KEY(id_vehicule) REFERENCES vehicule(id_vehicule)
);