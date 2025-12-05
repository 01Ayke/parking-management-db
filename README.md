# README - Système de Gestion de Parking

## Structure du projet

parking/
├── sql/                           # Scripts SQL
│   ├── create.sql                 # Création des tables
│   ├── drop.sql                   # Suppression des tables
│   ├── insert.sql                 # Insertion des données
│   ├── select.sql                 # Requêtes de consultation
│   └── update.sql                 # Requêtes de mise à jour
├── app/                           # Application web
│   ├── server/                    # Backend (Node.js)
│   └── public/                    # Frontend
├── rapport/                      # Sources du rapport
├── schema/                       # Schémas conceptuels
└── README.md                     # Ce fichier


**Description des dossiers :**
- `sql/` : Contient tous les scripts SQL (création, insertion, requêtes, etc.)
- `app/` : Application web complète (frontend + backend)
    - `app/server` : Backend 
    - `app/public` : Frontend
- `rapport/` : Sources du rapport LaTeX
- `schema/` : Schémas conceptuels de la base de données


--------------------------------------------------------------


Afin de lancer cette application, suivez les étapes ci-dessous: 


## 1. Création et initialisation de la base de données locale

1. Assurez-vous d’avoir PostgreSQL installé sur votre machine.
2. Créez une base dédiée pour les tests avec tes <user_name>, <base_name> et <password>.
    sudo -u postgres psql
    postgres=#  CREATE USER <user_name> WITH PASSWORD '<password>'; 
    postgres=#  CREATE DATABASE <base_name> OWNER <user_name>;

3. Pour créer les tables, exécutez :
    postgres=#  \i sql/create.sql 

4. Pour remplir les tables: 
    postgres=#  \i sql/insert.sql

## 2. Configuration du serveur pour se connecter à la base locale

Dans le répertoire ./app/, créez un fichier .env contenant les variables suivantes (à compléter pour correspondre à votre configuration locale):

    PGHOST=localhost
    PGUSER=<user_name>
    PGPASSWORD=<password>
    PGDATABASE=<base_name>
    PGPORT=5432

## 3. Lancement de l’application

1. Allez dans le répertoire ./app/server.
2. Pour Installez les dépendances ,exécutez:
    npm install
3. Démarrez le serveur :
    npm start

4. L’URL de l’application s’affichera dans le terminal. Ouvrez-la dans votre navigateur pour accéder à l’application.

## 4.Vous pouvez également accéder à l’application via notre URL publique : https://parking-app-521c.onrender.com

