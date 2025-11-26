const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_FILE = path.join(__dirname, 'parking.db');
const db = new sqlite3.Database(DB_FILE);

db.serialize(() => {
  console.log('Initialisation de la base...');

  
  db.run('PRAGMA foreign_keys = ON');

  db.run(`
    CREATE TABLE IF NOT EXISTS commune (
      id_commune   INTEGER PRIMARY KEY AUTOINCREMENT,
      code_postal  INTEGER,
      nom_commune  TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS parking (
      id_parking    INTEGER PRIMARY KEY AUTOINCREMENT,
      nom           TEXT,
      type_parking  TEXT,
      adresse       TEXT,
      capacite      INTEGER,
      id_commune    INTEGER,
      tarif_horaire REAL,
      FOREIGN KEY (id_commune) REFERENCES commune(id_commune)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS vehicule (
      num_immatriculation TEXT PRIMARY KEY,
      marque              TEXT,
      date_de_fabrication   TEXT,   -- YYYY-MM-DD
      kilometrage         INTEGER,
      etat                TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS place (
      id_place   INTEGER PRIMARY KEY AUTOINCREMENT,
      numero     INTEGER,
      etat       TEXT DEFAULT 'libre', -- 'libre' ou 'occupee'
      id_parking INTEGER,
      FOREIGN KEY (id_parking) REFERENCES parking(id_parking)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS creneau (
      id_creneau   INTEGER PRIMARY KEY AUTOINCREMENT,
      date_creneau TEXT,   -- YYYY-MM-DD
      heure_debut  TEXT,   -- HH:MM:SS
      heure_fin    TEXT,   -- HH:MM:SS ou NULL
      id_vehicule  TEXT,
      id_place     INTEGER,
      FOREIGN KEY (id_vehicule) REFERENCES vehicule(num_immatriculation),
      FOREIGN KEY (id_place)    REFERENCES place(id_place)
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS tarif (
      id_tarif INTEGER PRIMARY KEY AUTOINCREMENT,
      prix     REAL,    -- prix horaire
      date     TEXT     -- date d'entrée en vigueur
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS appliquer (
      id_parking INTEGER,
      id_tarif   INTEGER,
      PRIMARY KEY (id_parking, id_tarif),
      FOREIGN KEY (id_parking) REFERENCES parking(id_parking),
      FOREIGN KEY (id_tarif)   REFERENCES tarif(id_tarif)
    )
  `);

  
  
db.run("DELETE FROM appliquer");
db.run("DELETE FROM creneau");
db.run("DELETE FROM place");
db.run("DELETE FROM tarif");
db.run("DELETE FROM parking");
db.run("DELETE FROM vehicule");
db.run("DELETE FROM commune");

db.run("DELETE FROM sqlite_sequence WHERE name IN ('commune', 'parking', 'place', 'tarif')");


  const insertCommune = db.prepare(`
    INSERT INTO commune(code_postal, nom_commune)
    VALUES (?, ?)
  `);

  insertCommune.run(33000, 'Campus Nord');
  insertCommune.run(33100, 'Campus Sud');
  insertCommune.finalize();

  
  const insertParking = db.prepare(`
    INSERT INTO parking(nom, type_parking, adresse, capacite, id_commune, tarif_horaire)
    VALUES (?, ?, ?, ?, ?, ?)
  `);

  
  insertParking.run('Parking A',  'extérieur', 'Allée A', 3, 1, 2.0);
  insertParking.run('Parking B',  'souterrain', 'Allée B', 2, 1, 1.5);

  
  insertParking.run('Parking C',  'extérieur', 'Rue C', 4, 2, 1.8);

  insertParking.finalize();

  
  const insertPlace = db.prepare(`
    INSERT INTO place(numero, etat, id_parking)
    VALUES (?, 'libre', ?)
  `);
  
  insertPlace.run(1, 1);
  insertPlace.run(2, 1);
  insertPlace.run(3, 1);

  
  insertPlace.run(1, 2);
  insertPlace.run(2, 2);

  
  insertPlace.run(1, 3);
  insertPlace.run(2, 3);
  insertPlace.run(3, 3);
  insertPlace.run(4, 3);

  insertPlace.finalize();

  
  const insertVehicule = db.prepare(`
    INSERT INTO vehicule(num_immatriculation, marque, date_de_fabrication, kilometrage, etat)
    VALUES (?, ?, ?, ?, ?)
  `);

  insertVehicule.run('AA-111-AA', 'Renault', '2020-01-01', 30000, 'bon');
  insertVehicule.run('BB-222-BB', 'Peugeot', '2019-06-15', 45000, 'bon');
  insertVehicule.run('CC-333-CC', 'Citroen', '2018-09-10', 60000, 'moyen');

  insertVehicule.finalize();

  
  const insertTarif = db.prepare(`
    INSERT INTO tarif(prix, date)
    VALUES (?, ?)
  `);

  insertTarif.run(2.0, '2024-01-01');  
  insertTarif.run(1.5, '2024-01-01');  
  insertTarif.run(1.8, '2024-01-01');  

  insertTarif.finalize();

  
  const insertAppliquer = db.prepare(`
    INSERT INTO appliquer(id_parking, id_tarif)
    VALUES (?, ?)
  `);

  
  insertAppliquer.run(1, 1);

  
  insertAppliquer.run(2, 2);

  
  insertAppliquer.run(3, 3);

  insertAppliquer.finalize();

  

  const insertCreneau = db.prepare(`
    INSERT INTO creneau(date_creneau, heure_debut, heure_fin, id_vehicule, id_place)
    VALUES (?, ?, ?, ?, ?)
  `);

  
  insertCreneau.run('2024-01-10', '08:00:00', '10:00:00', 'AA-111-AA', 1);

  
  insertCreneau.run('2024-01-10', '09:30:00', '11:00:00', 'BB-222-BB', 2);

  
  
  insertCreneau.run('2024-01-11', '14:00:00', '15:15:00', 'CC-333-CC', 4);

  insertCreneau.finalize();

  console.log('Tables créées et données de test insérées.');
});

db.close(() => {
  console.log('Base fermée. parking.db est prête.');
});
