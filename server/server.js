
const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();

const app = express();
app.use(bodyParser.json());
const path = require('path');
app.use(express.static(path.join(__dirname, '../client')));



const db = new sqlite3.Database('./parking.db');


app.get('/places', (req, res) => {
  db.all('SELECT * FROM places', (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


app.post('/enter', (req, res) => {
  const { plaque } = req.body;

  db.get('SELECT * FROM places WHERE occupee = 0 LIMIT 1', (err, place) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!place) return res.status(400).json({ message: 'Parking plein' });

    const entree = new Date().toISOString();

    db.run(
      'UPDATE places SET occupee = 1, plaque = ? WHERE id = ?',
      [plaque, place.id],
      (err) => {
        if (err) return res.status(500).json({ error: err.message });

        db.run(
          'INSERT INTO tickets(plaque, place_id, entree) VALUES(?,?,?)',
          [plaque, place.id, entree],
          (err) => {
            if (err) return res.status(500).json({ error: err.message });

            res.json({ message: 'Entrée enregistrée', place });
          }
        );
      }
    );
  });
});


app.post('/exit', (req, res) => {
  const { plaque } = req.body;

  db.get(
    `SELECT t.*, p.name as place_name 
     FROM tickets t 
     JOIN places p ON p.id = t.place_id 
     WHERE t.plaque = ? AND t.sortie IS NULL 
     ORDER BY t.id DESC LIMIT 1`,
    [plaque],
    (err, ticket) => {
      if (err) return res.status(500).json({ error: err.message });
      if (!ticket) return res.status(400).json({ message: 'Ticket introuvable' });

      const sortie = new Date().toISOString();
      const entreeDate = new Date(ticket.entree);
      const diffMs = new Date(sortie) - entreeDate;
      const hours = Math.max(0.5, diffMs / 3600000);
      const prix = Math.round(hours * 0.5 * 100) / 100;

      db.run(
        'UPDATE tickets SET sortie = ?, prix = ? WHERE id = ?',
        [sortie, prix, ticket.id],
        (err) => {
          if (err) return res.status(500).json({ error: err.message });

          db.run(
            'UPDATE places SET occupee = 0, plaque = NULL WHERE id = ?',
            [ticket.place_id],
            (err) => {
              if (err) return res.status(500).json({ error: err.message });
              res.json({ message: 'Sortie enregistrée', prix, ticket });
            }
          );
        }
      );
    }
  );
});


app.listen(3000, () => console.log('Serveur démarré sur http://localhost:3000'));
