
-- ==========================
-- Table : Commune
-- ==========================
INSERT INTO commune (code_postal, nom_commune) VALUES
(33000, 'Bordeaux'),
(75001, 'Paris 1er'),
(69001, 'Lyon 1er'),
(13001, 'Marseille 1er'),
(06000, 'Nice'),
(31000, 'Toulouse'),
(44000, 'Nantes'),
(67000, 'Strasbourg');

-- ==========================
-- Table : Parking (1 par commune)
-- ==========================
INSERT INTO parking (nom, type_parking, adresse, capacite, id_commune) VALUES
('Parking Mériadeck', 'Couvert', 'Rue Mériadeck, Bordeaux', 10, 1),
('Parking République', 'Découvert', '10 Rue de la République, Paris', 10, 2),
('Parking Bellecour', 'Couvert', 'Place Bellecour, Lyon', 10, 3),
('Parking Vieux-Port', 'Découvert', 'Quai du Port, Marseille', 10, 4),
('Parking Promenade', 'Découvert', 'Promenade des Anglais, Nice', 10, 5),
('Parking Capitole', 'Couvert', 'Place du Capitole, Toulouse', 10, 6),
('Parking Graslin', 'Découvert', 'Place Graslin, Nantes', 10, 7),
('Parking Kléber', 'Couvert', 'Place Kléber, Strasbourg', 10, 8);

-- ==========================
-- Table : Place (10 par parking)
-- ==========================
INSERT INTO place (etat, id_parking) VALUES
-- Parking 1
('Libre', 1),('Occupée', 1),('Libre', 1),('Occupée', 1),('Libre', 1),
('Occupée', 1),('Libre', 1),('Occupée', 1),('Libre', 1),('Occupée', 1),
-- Parking 2
('Libre', 2),('Occupée', 2),('Libre', 2),('Occupée', 2),('Libre', 2),
('Occupée', 2),('Libre', 2),('Occupée', 2),('Libre', 2),('Occupée', 2),
-- Parking 3
('Libre', 3),('Occupée', 3),('Libre', 3),('Occupée', 3),('Libre', 3),
('Occupée', 3),('Libre', 3),('Occupée', 3),('Libre', 3),('Occupée', 3),
-- Parking 4
('Libre', 4),('Occupée', 4),('Libre', 4),('Occupée', 4),('Libre', 4),
('Occupée', 4),('Libre', 4),('Occupée', 4),('Libre', 4),('Occupée', 4),
-- Parking 5
('Libre', 5),('Occupée', 5),('Libre', 5),('Occupée', 5),('Libre', 5),
('Occupée', 5),('Libre', 5),('Occupée', 5),('Libre', 5),('Occupée', 5),
-- Parking 6
('Libre', 6),('Occupée', 6),('Libre', 6),('Occupée', 6),('Libre', 6),
('Occupée', 6),('Libre', 6),('Occupée', 6),('Libre', 6),('Occupée', 6),
-- Parking 7
('Libre', 7),('Occupée', 7),('Libre', 7),('Occupée', 7),('Libre', 7),
('Occupée', 7),('Libre', 7),('Occupée', 7),('Libre', 7),('Occupée', 7),
-- Parking 8
('Libre', 8),('Occupée', 8),('Libre', 8),('Occupée', 8),('Libre', 8),
('Occupée', 8),('Libre', 8),('Occupée', 8),('Libre', 8),('Occupée', 8);

-- ==========================
-- Table : Véhicule (30 véhicules)
-- ==========================
INSERT INTO vehicule (marque, date_de_fabrication, etat, kilometrage) VALUES
('Renault Clio', '2018-03-15', 'Bon état', 45000),
('Peugeot 208', '2020-07-22', 'Neuf', 15000),
('Tesla Model 3', '2022-01-10', 'Excellent', 5000),
('Ford Fiesta', '2017-09-30', 'Correct', 75000),
('BMW Série 3', '2019-11-05', 'Très bon', 30000),
('Audi A3', '2021-05-18', 'Neuf', 12000),
('Mercedes Classe C', '2018-12-01', 'Bon état', 40000),
('Volkswagen Golf', '2019-04-20', 'Correct', 50000),
('Toyota Yaris', '2020-08-15', 'Très bon', 20000),
('Honda Civic', '2021-03-10', 'Neuf', 10000),
('Nissan Qashqai', '2019-11-12', 'Correct', 55000),
('Renault Captur', '2022-06-25', 'Excellent', 8000),
('Peugeot 3008', '2020-02-14', 'Très bon', 25000),
('Tesla Model Y', '2022-09-05', 'Neuf', 5000),
('Ford Focus', '2017-10-20', 'Correct', 65000),
('BMW X1', '2019-07-30', 'Très bon', 30000),
('Audi Q2', '2020-01-12', 'Neuf', 15000),
('Mercedes GLA', '2021-11-18', 'Très bon', 18000),
('Volkswagen Polo', '2018-05-22', 'Correct', 47000),
('Toyota Corolla', '2019-09-15', 'Bon état', 35000),
('Honda Jazz', '2020-12-05', 'Neuf', 12000),
('Nissan Micra', '2021-06-10', 'Très bon', 10000),
('Renault Megane', '2018-04-30', 'Correct', 52000),
('Peugeot 208', '2019-08-25', 'Bon état', 40000),
('Tesla Model 3', '2022-01-30', 'Neuf', 5000),
('Ford Puma', '2020-11-12', 'Très bon', 15000),
('BMW Série 1', '2019-02-28', 'Correct', 45000),
('Audi A1', '2021-07-10', 'Neuf', 12000),
('Mercedes Classe A', '2020-05-20', 'Très bon', 20000),
('Volkswagen T-Roc', '2019-09-01', 'Correct', 35000);

-- ==========================
-- Table : Créneau (10 créneaux)
-- ==========================
INSERT INTO creneau (date_creneau, heure_debut, heure_fin, id_vehicule, id_place) VALUES
('2025-11-15', '08:00', '10:00', 1, 1),
('2025-11-15', '10:30', '12:30', 2, 2),
('2025-11-16', '09:00', '11:00', 3, 3),
('2025-11-16', '14:00', '16:00', 4, 4),
('2025-11-17', '13:00', '15:00', 5, 5),
('2025-11-17', '15:30', '17:30', 6, 6),
('2025-11-18', '08:00', '10:00', 7, 7),
('2025-11-18', '10:30', '12:30', 8, 8),
('2025-11-19', '09:00', '11:00', 9, 9),
('2025-11-19', '14:00', '16:00', 10, 10);

-- ==========================
-- Table : Tarif
-- ==========================
INSERT INTO tarif (prix, date) VALUES
(2.50, '2025-01-01'),
(3.00, '2025-06-01'),
(1.50, '2025-03-01');

-- ==========================
-- Table : Appliquer
-- ==========================
INSERT INTO appliquer (id_parking, id_tarif) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2),
(6, 3),
(7, 1),
(8, 2);