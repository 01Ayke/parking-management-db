

const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./parking.db');


db.serialize(() => {
db.run(`CREATE TABLE IF NOT EXISTS places (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
occupee INTEGER DEFAULT 0,
plaque TEXT
)`);


db.run(`CREATE TABLE IF NOT EXISTS tickets (
id INTEGER PRIMARY KEY AUTOINCREMENT,
plaque TEXT,
place_id INTEGER,
entree TEXT,
sortie TEXT,
prix REAL
)`);


// Juste pour tester (on ajoute des places vides)
const insert = db.prepare('INSERT INTO places(name, occupee) VALUES(?,?)');
for (let i = 1; i <= 5; i++) insert.run('P' + i, 0);
insert.finalize();


console.log('Base initialisée : parking.db');
});


db.close();