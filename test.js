
require('dotenv').config();
const { Client } = require('pg');

const client = new Client({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
});

a = async () => {
  await client.connect();

  await client.query('DELETE FROM cars;');

  await client.query(
    'INSERT INTO cars (make, model, year, license_plate) VALUES ($1, $2, $3, $4)',
    ['Toyota', 'Camry', 2022, 'ABC13']
  );

  await client.query(
    'INSERT INTO cars (make, model, year, license_plate) VALUES ($1, $2, $3, $4)',
    ['Toyota', 'Camry', 2,'ABC123']
  );
  
  
  const res = await client.query('SELECT * FROM cars;');
  console.log(res.rows);
  await client.end();
}

a();