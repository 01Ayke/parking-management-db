const { Pool } = require('pg');
const path = require('path');

const envPath = path.join('../.env');
console.log('Loading .env from:', envPath);

require('dotenv').config({ path: envPath });

const pool = new Pool({
    user: process.env.PGUSER,
    host: process.env.PGHOST,
    database: process.env.PGDATABASE,
    password: process.env.PGPASSWORD,
    port: process.env.DB_PORT,
});

pool.connect((err, client, release) => {
    if (err) {
        console.error('Error connecting to PostgreSQL: ' + process.env.PGPASSWORD + ' ' , err.message);
    } else {
        console.log('Successfully connected to PostgreSQL database');
        release();
    }
});

module.exports = {
    query: (text, params) => pool.query(text, params),
    pool
};