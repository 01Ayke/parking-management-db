const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const app = express();


app.use((req, res, next) => {
  console.log(req.method, req.url);
  next();
});


app.use(express.json());


app.use(express.static(path.join(__dirname, '../client')));


const db = new sqlite3.Database(path.join(__dirname, 'parking.db'), (err) => {
  if (err) console.error('Erreur SQLite :', err.message);
  else console.log('SQLite connecté.');
});


db.run('PRAGMA foreign_keys = ON');


app.get('/places', (req, res) => {
  const sql = `
    SELECT place.id_place, place.etat, place.id_parking, parking.nom AS nom_parking
    FROM place
    LEFT JOIN parking ON parking.id_parking = place.id_parking
    ORDER BY place.id_place
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});



app.post('/enter', (req, res) => {
  const { plaque } = req.body;
  if (!plaque) {
    return res.status(400).json({ error: 'Plaque manquante' });
  }

  const now = new Date();
  const date = now.toISOString().slice(0, 10);       
  const time = now.toTimeString().slice(0, 8);       

  db.serialize(() => {
    
    db.run(
      `INSERT OR IGNORE INTO vehicule(num_immatriculation, marque, date_de_fabrication, etat, kilometrage)
       VALUES (?, NULL, NULL, NULL, NULL)`,
      [plaque],
      (err) => {
        if (err) return res.status(500).json({ error: err.message });

        
        db.get(
          `SELECT * FROM place WHERE etat = 'libre' LIMIT 1`,
          [],
          (err2, placeRow) => {
            if (err2) return res.status(500).json({ error: err2.message });
            if (!placeRow) {
              return res.status(400).json({ message: 'Parking plein (aucune place libre)' });
            }

            const id_place = placeRow.id_place;

            
            db.run(
              `UPDATE place SET etat = 'occupee' WHERE id_place = ?`,
              [id_place],
              (err3) => {
                if (err3) return res.status(500).json({ error: err3.message });

                
                db.run(
                  `INSERT INTO creneau(date_creneau, heure_debut, heure_fin, id_vehicule, id_place)
                   VALUES (?, ?, NULL, ?, ?)`,
                  [date, time, plaque, id_place],
                  function (err4) {
                    if (err4) return res.status(500).json({ error: err4.message });

                    res.json({
                      message: 'Entrée enregistrée',
                      vehicule: plaque,
                      place: id_place,
                      date_creneau: date,
                      heure_debut: time,
                      id_creneau: this.lastID
                    });
                  }
                );
              }
            );
          }
        );
      }
    );
  });
});



app.post('/exit', (req, res) => {
  const { plaque } = req.body;
  if (!plaque) {
    return res.status(400).json({ error: 'Plaque manquante' });
  }

  const now = new Date();
  const date = now.toISOString().slice(0, 10);       
  const time = now.toTimeString().slice(0, 8);       

  db.serialize(() => {
    
    const sqlCreneau = `
      SELECT creneau.*, place.id_parking
      FROM creneau
      JOIN place ON place.id_place = creneau.id_place
      WHERE creneau.id_vehicule = ?
        AND creneau.heure_fin IS NULL
      ORDER BY creneau.id_creneau DESC
      LIMIT 1
    `;
    db.get(sqlCreneau, [plaque], (err, creneauRow) => {
      if (err) return res.status(500).json({ error: err.message });
      if (!creneauRow) {
        return res.status(400).json({ message: 'Aucun créneau ouvert pour ce véhicule.' });
      }

      
      const debutStr = `${creneauRow.date_creneau}T${creneauRow.heure_debut}`;
      const debut = new Date(debutStr);
      const diffMs = now - debut;
      let hours = diffMs / 3_600_000; 
      if (hours < 0.5) hours = 0.5;   

      
      const sqlTarif = `
        SELECT prix
        FROM tarif
        JOIN appliquer ON appliquer.id_tarif = tarif.id_tarif
        WHERE appliquer.id_parking = ?
        ORDER BY date DESC
        LIMIT 1
      `;
      db.get(sqlTarif, [creneauRow.id_parking], (err2, tarifRow) => {
        if (err2) return res.status(500).json({ error: err2.message });

        const prixHoraire = tarifRow ? tarifRow.prix : 1.0;
        const prix = Math.round(hours * prixHoraire * 100) / 100;

        
        db.run(
          `UPDATE creneau
           SET heure_fin = ?
           WHERE id_creneau = ?`,
          [time, creneauRow.id_creneau],
          (err3) => {
            if (err3) return res.status(500).json({ error: err3.message });

            
            db.run(
              `UPDATE place SET etat = 'libre' WHERE id_place = ?`,
              [creneauRow.id_place],
              (err4) => {
                if (err4) return res.status(500).json({ error: err4.message });

                res.json({
                  message: 'Sortie enregistrée',
                  vehicule: plaque,
                  duree_heures: hours,
                  prix,
                  id_creneau: creneauRow.id_creneau
                });
              }
            );
          }
        );
      });
    });
  });
});






app.get('/consult/infos', (req, res) => {
  const result = {};

  db.all(`SELECT * FROM parking`, [], (errP, parkings) => {
    if (errP) return res.status(500).json({ error: errP.message });
    result.parkings = parkings;

    db.all(`SELECT * FROM vehicule`, [], (errV, vehicules) => {
      if (errV) return res.status(500).json({ error: errV.message });
      result.vehicules = vehicules;

      db.all(
        `SELECT place.*, parking.nom AS nom_parking
         FROM place
         LEFT JOIN parking ON parking.id_parking = place.id_parking`,
        [],
        (errPl, places) => {
          if (errPl) return res.status(500).json({ error: errPl.message });
          result.places = places;
          res.json(result);
        }
      );
    });
  });
});


app.get('/consult/voitures-par-parking', (req, res) => {
  const { id_parking } = req.query;
  const sql = `
    SELECT DISTINCT v.*
    FROM vehicule v
    JOIN creneau c ON c.id_vehicule = v.num_immatriculation
    JOIN place p ON p.id_place = c.id_place
    WHERE p.id_parking = ?
  `;
  db.all(sql, [id_parking], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


app.get('/consult/parkings-par-commune', (req, res) => {
  const { id_commune } = req.query;
  const sql = `
    SELECT *
    FROM parking
    WHERE id_commune = ?
  `;
  db.all(sql, [id_commune], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});



app.get('/consult/parkings-satures', (req, res) => {
  const { jour } = req.query;
  const sql = `
    SELECT pk.*, COUNT(c.id_creneau) AS nb_creneaux
    FROM parking pk
    JOIN place pl ON pl.id_parking = pk.id_parking
    JOIN creneau c ON c.id_place = pl.id_place
    WHERE c.date_creneau = ?
    GROUP BY pk.id_parking
    HAVING nb_creneaux >= pk.capacite
  `;
  db.all(sql, [jour], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


app.get('/consult/places-disponibles', (req, res) => {
  const { id_parking, jour, heure } = req.query;

  const sql = `
    SELECT pl.*
    FROM place pl
    WHERE pl.id_parking = ?
      AND NOT EXISTS (
        SELECT 1
        FROM creneau c
        WHERE c.id_place = pl.id_place
          AND c.date_creneau = ?
          AND c.heure_debut <= ?
          AND (c.heure_fin IS NULL OR c.heure_fin > ?)
      )
  `;
  db.all(sql, [id_parking, jour, heure, heure], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


app.get('/consult/voitures-multi-parkings', (req, res) => {
  const { jour } = req.query;
  const sql = `
    SELECT v.num_immatriculation,
           COUNT(DISTINCT pk.id_parking) AS nb_parkings
    FROM vehicule v
    JOIN creneau c ON c.id_vehicule = v.num_immatriculation
    JOIN place pl ON pl.id_place = c.id_place
    JOIN parking pk ON pk.id_parking = pl.id_parking
    WHERE c.date_creneau = ?
    GROUP BY v.num_immatriculation
    HAVING nb_parkings >= 2
  `;
  db.all(sql, [jour], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});







app.get('/stat/moyenne-places-disponibles', (req, res) => {
  const sql = `
    SELECT pk.id_parking,
           pk.nom,
           pk.capacite,
           (pk.capacite - IFNULL(avgO.cc, 0)) AS moyenne_places_disponibles
    FROM parking pk
    LEFT JOIN (
      SELECT pl.id_parking,
             c.date_creneau,
             COUNT(DISTINCT c.id_place) AS cc
      FROM creneau c
      JOIN place pl ON pl.id_place = c.id_place
      GROUP BY pl.id_parking, c.date_creneau
    ) AS avgO
    ON avgO.id_parking = pk.id_parking
    GROUP BY pk.id_parking
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


app.get('/stat/duree-moyenne-stationnement', (req, res) => {
  const sql = `
    SELECT pk.id_parking,
           pk.nom,
           AVG(
             (julianday(c.date_creneau || ' ' || c.heure_fin)
              - julianday(c.date_creneau || ' ' || c.heure_debut)
             ) * 24.0
           ) AS duree_moyenne_heures
    FROM creneau c
    JOIN place pl ON pl.id_place = c.id_place
    JOIN parking pk ON pk.id_parking = pl.id_parking
    WHERE c.heure_fin IS NOT NULL
    GROUP BY pk.id_parking
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});



app.get('/stat/cout-moyen-mensuel', (req, res) => {
  const sql = `
    SELECT v.num_immatriculation,
           strftime('%Y-%m', c.date_creneau) AS mois,
           AVG(
             (
               (julianday(c.date_creneau || ' ' || c.heure_fin)
                - julianday(c.date_creneau || ' ' || c.heure_debut)
               ) * 24.0
             ) * IFNULL(t.prix, 1.0)
           ) AS cout_moyen
    FROM creneau c
    JOIN vehicule v ON v.num_immatriculation = c.id_vehicule
    JOIN place pl ON pl.id_place = c.id_place
    JOIN parking pk ON pk.id_parking = pl.id_parking
    LEFT JOIN appliquer a ON a.id_parking = pk.id_parking
    LEFT JOIN tarif t ON t.id_tarif = a.id_tarif
    WHERE c.heure_fin IS NOT NULL
    GROUP BY v.num_immatriculation, mois
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


app.get('/stat/parkings-moins-utilises', (req, res) => {
  const sql = `
    SELECT pk.id_parking,
           pk.nom,
           COUNT(c.id_creneau) AS nb_creneaux
    FROM parking pk
    LEFT JOIN place pl ON pl.id_parking = pk.id_parking
    LEFT JOIN creneau c ON c.id_place = pl.id_place
    GROUP BY pk.id_parking
    ORDER BY nb_creneaux ASC
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});



app.get('/stat/parkings-plus-rentables', (req, res) => {
  const sql = `
    SELECT pk.id_parking,
           pk.nom,
           pk.id_commune,
           strftime('%Y-%m', c.date_creneau) AS mois,
           SUM(
             (
               (julianday(c.date_creneau || ' ' || c.heure_fin)
                - julianday(c.date_creneau || ' ' || c.heure_debut)
               ) * 24.0
             ) * IFNULL(t.prix, 1.0)
           ) AS revenu
    FROM creneau c
    JOIN place pl ON pl.id_place = c.id_place
    JOIN parking pk ON pk.id_parking = pl.id_parking
    LEFT JOIN appliquer a ON a.id_parking = pk.id_parking
    LEFT JOIN tarif t ON t.id_tarif = a.id_tarif
    WHERE c.heure_fin IS NOT NULL
    GROUP BY pk.id_parking, mois
    ORDER BY revenu DESC
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});



app.get('/stat/communes-plus-demandees', (req, res) => {
  const sql = `
    SELECT co.id_commune,
           co.nom_commune,
           strftime('%Y-%W', c.date_creneau) AS semaine,
           COUNT(c.id_creneau) AS nb_stationnements
    FROM creneau c
    JOIN place pl ON pl.id_place = c.id_place
    JOIN parking pk ON pk.id_parking = pl.id_parking
    JOIN commune co ON co.id_commune = pk.id_commune
    GROUP BY co.id_commune, semaine
    ORDER BY nb_stationnements DESC
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});





app.listen(3000, () => {
  console.log('Serveur démarré sur http://localhost:3000');
  console.log('Ouvre http://localhost:3000/client.html');
});
