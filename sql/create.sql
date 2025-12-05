-- ============================================================
--   Table : Commune                                            
-- ============================================================
CREATE TABLE commune (
    id_commune SERIAL PRIMARY KEY,
    code_postal INTEGER NOT NULL CHECK (code_postal BETWEEN 1000 AND 99999),
    nom_commune VARCHAR(255) NOT NULL,
    UNIQUE(code_postal, nom_commune)
);

-- ============================================================
--   Table : Parking                                            
-- ============================================================
CREATE TABLE parking (
    id_parking SERIAL PRIMARY KEY,
    nom_parking VARCHAR(255) NOT NULL,
    type_parking VARCHAR(255),
    adresse VARCHAR(255),
    capacite INTEGER NOT NULL CHECK (capacite > 0),
    id_commune INTEGER NOT NULL,
    CONSTRAINT fk_parking_commune FOREIGN KEY(id_commune) REFERENCES commune(id_commune)
);

-- ============================================================
--   Table : Catégorie place                                            
-- ============================================================
CREATE TYPE genre_type AS ENUM ('Voiture', 'Moto', 'Electrique', 'Van');

CREATE TABLE categorie_place (
    id_categorie_place SERIAL PRIMARY KEY,
    type_place genre_type NOT NULL UNIQUE
);

-- ============================================================
--   Table : Place                                            
-- ============================================================
CREATE TABLE place (
    id_place SERIAL PRIMARY KEY,
    num_place VARCHAR(255) NOT NULL,
    etat_place VARCHAR(255) CHECK (etat_place IN ('Libre', 'Occupée', 'Réservée', 'Hors service')),
    id_parking INTEGER NOT NULL,
    id_categorie_place INTEGER NOT NULL,
    CONSTRAINT fk_place_parking FOREIGN KEY(id_parking) REFERENCES parking(id_parking),
    CONSTRAINT fk_place_categorie_place FOREIGN KEY(id_categorie_place) REFERENCES categorie_place(id_categorie_place),
    UNIQUE(id_parking, num_place)
);

-- ============================================================
--   Table : Utilisateur                                            
-- ============================================================
CREATE TABLE utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    p_identite VARCHAR(255) NOT NULL UNIQUE
);

-- ============================================================
--   Table : Véhicule                                            
-- ============================================================
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    num_immatriculation VARCHAR(255) NOT NULL UNIQUE,
    marque_vehicule VARCHAR(255),
    genre_vehicule genre_type NOT NULL,
    date_de_fabrication DATE CHECK (date_de_fabrication <= CURRENT_DATE),
    etat_vehicule VARCHAR(255) CHECK (etat_vehicule IN ('Excellent', 'Bon', 'Moyen', 'Mauvais')),
    kilometrage INTEGER CHECK (kilometrage >= 0),
    id_utilisateur INTEGER,
    CONSTRAINT fk_vehicule_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);

-- ============================================================
--   Table : Abonnement                                            
-- ============================================================
CREATE TYPE genre_abonnement AS ENUM ('AU','AV');

CREATE TABLE abonnement (
    id_abonnement SERIAL PRIMARY KEY,
    date_debut_abonnement DATE NOT NULL,
    date_fin_abonnement DATE NOT NULL,
    type_abonnement genre_abonnement NOT NULL,
    tarif_mensuel_abonnement NUMERIC(10,2) NOT NULL CHECK (tarif_mensuel_abonnement > 0),
    CONSTRAINT check_dates_abonnement CHECK (date_fin_abonnement >= date_debut_abonnement)
);

-- ============================================================
--   Table : Posséder AV                                           
-- ============================================================
CREATE TABLE posseder_av (
    id_vehicule INTEGER NOT NULL,
    id_abonnement INTEGER NOT NULL,
    CONSTRAINT fk_posseder_av_vehicule FOREIGN KEY(id_vehicule) REFERENCES vehicule(id_vehicule),
    CONSTRAINT fk_posseder_av_abonnement FOREIGN KEY(id_abonnement) REFERENCES abonnement(id_abonnement),
    PRIMARY KEY (id_vehicule, id_abonnement)
);

-- ============================================================
--   Table : Posséder AU                                      
-- ============================================================
CREATE TABLE posseder_au (
    id_utilisateur INTEGER NOT NULL,
    id_abonnement INTEGER NOT NULL,
    CONSTRAINT fk_posseder_au_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    CONSTRAINT fk_posseder_au_abonnement FOREIGN KEY(id_abonnement) REFERENCES abonnement(id_abonnement),
    PRIMARY KEY (id_utilisateur, id_abonnement)
);

-- ============================================================
--   Table : Stationnement
-- ============================================================
CREATE TABLE stationnement (
    id_stationnement SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    mode_paiement VARCHAR(255) CHECK (mode_paiement IN ('Carte', 'Espèces', 'Mobile', 'Abonnement')),
    id_vehicule INTEGER NOT NULL,
    id_place INTEGER NOT NULL,
    id_utilisateur INTEGER NOT NULL,
    CONSTRAINT fk_stationnement_vehicule FOREIGN KEY(id_vehicule) REFERENCES vehicule(id_vehicule),
    CONSTRAINT fk_stationnement_place FOREIGN KEY(id_place) REFERENCES place(id_place),
    CONSTRAINT fk_stationnement_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur),
    CONSTRAINT check_dates_stationnement CHECK (date_fin >= date_debut)
);

-- ============================================================
--   Table : Tarif                                            
-- ============================================================
CREATE TABLE tarif (
    id_tarif SERIAL PRIMARY KEY
);

-- ============================================================
--   Table : Creneau
-- ============================================================
CREATE TABLE creneau (
    id_creneau SERIAL PRIMARY KEY,
    prix NUMERIC(5,2) NOT NULL CHECK (prix >= 0),
    debut_creneau TIME NOT NULL,
    fin_creneau TIME NOT NULL,
    CONSTRAINT check_creneau_different CHECK (debut_creneau != fin_creneau)
);

-- ============================================================
--   Table : Diviser                                            
-- ============================================================
CREATE TABLE diviser (
    id_creneau INTEGER REFERENCES creneau(id_creneau),
    id_tarif INTEGER REFERENCES tarif(id_tarif),
    PRIMARY KEY (id_creneau, id_tarif)
);

-- ============================================================
--   Table : Compte                                            
-- ============================================================
CREATE TABLE compte (
    id_compte SERIAL PRIMARY KEY,
    identifiant VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    date_creation DATE NOT NULL DEFAULT CURRENT_DATE,
    date_derniere_connexion TIMESTAMP,
    actif BOOLEAN DEFAULT true,
    id_utilisateur INTEGER NOT NULL UNIQUE,
    CONSTRAINT fk_compte_utilisateur FOREIGN KEY(id_utilisateur) REFERENCES utilisateur(id_utilisateur)
);

-- ============================================================
--   Table : Appliquer                                            
-- ============================================================
CREATE TABLE appliquer (
    id_parking INTEGER REFERENCES parking(id_parking),
    id_categorie_place INTEGER REFERENCES categorie_place(id_categorie_place),
    id_tarif INTEGER REFERENCES tarif(id_tarif),
    PRIMARY KEY (id_parking, id_categorie_place)
);

-- ============================================================
--   Table : Proposer A[UV]                                         
-- ============================================================
CREATE TABLE proposer_auv (
    id_abonnement INTEGER NOT NULL,
    id_parking INTEGER NOT NULL,
    CONSTRAINT fk_proposer_auv_abonnement FOREIGN KEY(id_abonnement) REFERENCES abonnement(id_abonnement),
    CONSTRAINT fk_proposer_auv_parking FOREIGN KEY(id_parking) REFERENCES parking(id_parking),
    PRIMARY KEY (id_abonnement, id_parking)
);