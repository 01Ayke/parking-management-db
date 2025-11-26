-- ==========================
-- Table : Commune
-- ==========================
INSERT INTO commune (code_postal, nom_commune) VALUES
(33000, 'Bordeaux'),
(33400, 'Talence'),
(33600, 'Pessac'),
(33170, 'Gradignan');

-- ==========================
-- Table : Parking
-- ==========================
INSERT INTO parking (nom_parking, type_parking, adresse, capacite, id_commune) VALUES
('Parking Peixotto', 'Couvert', '1 Avenue du Docteur Albert Schweitzer, Talence', 50, 2),
('Parking Forum', 'Découvert', 'Place du Forum, Talence', 30, 2),
('Parking ENSEIRB', 'Couvert', '1 Avenue du Docteur Albert Schweitzer, Talence', 100, 2),
('Parking Pessac Centre', 'Découvert', 'Avenue du Maréchal Leclerc, Pessac', 40, 3),
('Parking Gradignan', 'Couvert', 'Cours du Général de Gaulle, Gradignan', 60, 4);

-- ==========================
-- Table : Place
-- ==========================
INSERT INTO place (num_place, etat_place, id_parking) VALUES
-- Parking 1 (Peixotto) - 10 places
('A01', 'Libre', 1),
('A02', 'Occupée', 1),
('A03', 'Libre', 1),
('A04', 'Occupée', 1),
('A05', 'Libre', 1),
('B01', 'Occupée', 1),
('B02', 'Libre', 1),
('B03', 'Occupée', 1),
('B04', 'Libre', 1),
('B05', 'Occupée', 1),

-- Parking 2 (Forum) - 10 places
('A01', 'Libre', 2),
('A02', 'Occupée', 2),
('A03', 'Libre', 2),
('A04', 'Occupée', 2),
('A05', 'Libre', 2),
('B01', 'Occupée', 2),
('B02', 'Libre', 2),
('B03', 'Occupée', 2),
('B04', 'Libre', 2),
('B05', 'Occupée', 2),

-- Parking 3 (ENSEIRB) - 10 places
('C01', 'Libre', 3),
('C02', 'Occupée', 3),
('C03', 'Libre', 3),
('C04', 'Occupée', 3),
('C05', 'Libre', 3),
('D01', 'Occupée', 3),
('D02', 'Libre', 3),
('D03', 'Occupée', 3),
('D04', 'Libre', 3),
('D05', 'Occupée', 3),

-- Parking 4 (Pessac) - 5 places
('P01', 'Libre', 4),
('P02', 'Occupée', 4),
('P03', 'Libre', 4),
('P04', 'Occupée', 4),
('P05', 'Libre', 4),

-- Parking 5 (Gradignan) - 5 places
('G01', 'Libre', 5),
('G02', 'Occupée', 5),
('G03', 'Libre', 5),
('G04', 'Occupée', 5),
('G05', 'Libre', 5);

-- ==========================
-- Table : Véhicule
-- ==========================
INSERT INTO vehicule (num_immatriculation, marque_vehicule, date_de_fabrication, etat_vehicule, kilometrage) VALUES
('AB-123-CD', 'Renault Clio', '2018-03-15', 'Bon état', 45000),
('EF-456-GH', 'Peugeot 208', '2020-07-22', 'Neuf', 15000),
('IJ-789-KL', 'Tesla Model 3', '2022-01-10', 'Excellent', 5000),
('MN-012-OP', 'Ford Fiesta', '2017-09-30', 'Correct', 75000),
('QR-345-ST', 'BMW Série 3', '2019-11-05', 'Très bon', 30000),
('UV-678-WX', 'Audi A3', '2021-05-18', 'Neuf', 12000),
('YZ-901-AB', 'Mercedes Classe C', '2018-12-01', 'Bon état', 40000),
('CD-234-EF', 'Volkswagen Golf', '2019-04-20', 'Correct', 50000),
('GH-567-IJ', 'Toyota Yaris', '2020-08-15', 'Très bon', 20000),
('KL-890-MN', 'Honda Civic', '2021-03-10', 'Neuf', 10000),
('OP-123-QR', 'Nissan Qashqai', '2019-11-12', 'Correct', 55000),
('ST-456-UV', 'Renault Captur', '2022-06-25', 'Excellent', 8000),
('WX-789-YZ', 'Peugeot 3008', '2020-02-14', 'Très bon', 25000),
('AB-012-CD', 'Tesla Model Y', '2022-09-05', 'Neuf', 5000),
('EF-345-GH', 'Ford Focus', '2017-10-20', 'Correct', 65000);

-- ==========================
-- Table : Créneau
-- ==========================
INSERT INTO creneau (date_debut, date_fin, heure_debut, heure_fin, mode_paiement, id_vehicule, id_place) VALUES
-- Créneaux du 25 novembre 2025
('2025-11-25', '2025-11-25', '08:00', '10:00', 'CB', 1, 2),
('2025-11-25', '2025-11-25', '08:30', '12:30', 'Espèces', 2, 4),
('2025-11-25', '2025-11-25', '09:00', '11:00', 'CB', 3, 6),
('2025-11-25', '2025-11-25', '14:00', '16:00', 'Abonnement', 4, 8),
('2025-11-25', '2025-11-25', '13:00', '17:00', 'CB', 5, 10),

-- Créneaux du 26 novembre 2025
('2025-11-26', '2025-11-26', '08:00', '12:00', 'CB', 6, 12),
('2025-11-26', '2025-11-26', '09:00', '11:30', 'Espèces', 7, 14),
('2025-11-26', '2025-11-26', '10:00', '15:00', 'Abonnement', 8, 16),
('2025-11-26', '2025-11-26', '14:00', '18:00', 'CB', 9, 18),
('2025-11-26', '2025-11-26', '15:00', '17:00', 'Espèces', 10, 20),

-- Créneaux du 27 novembre 2025
('2025-11-27', '2025-11-27', '08:00', '10:00', 'CB', 11, 22),
('2025-11-27', '2025-11-27', '09:00', '12:00', 'Abonnement', 12, 24),
('2025-11-27', '2025-11-27', '13:00', '16:00', 'CB', 13, 26),
('2025-11-27', '2025-11-27', '14:00', '17:00', 'Espèces', 14, 28),
('2025-11-27', '2025-11-27', '15:00', '18:00', 'CB', 15, 30),

-- Véhicule qui se gare dans 2 parkings différents le même jour
('2025-11-26', '2025-11-26', '08:00', '10:00', 'CB', 1, 22),  -- Parking 3
('2025-11-26', '2025-11-26', '14:00', '16:00', 'CB', 1, 32),  -- Parking 4

-- ==========================
-- Table : Tarif
-- ==========================
INSERT INTO tarif (prix, type_jour, heure_debut_tarif, heure_fin_tarif, date_debut_tarif, date_fin_tarif) VALUES
-- Tarifs en semaine
(2.50, 'WEEKDAY', '08:00', '18:00', '2025-01-01', '2025-12-31'),
(1.50, 'WEEKDAY', '18:00', '22:00', '2025-01-01', '2025-12-31'),

-- Tarifs weekend
(3.00, 'WEEKEND', '08:00', '18:00', '2025-01-01', '2025-12-31'),
(2.00, 'WEEKEND', '18:00', '22:00', '2025-01-01', '2025-12-31'),

-- Tarifs jours fériés
(3.50, 'HOLIDAY', '08:00', '22:00', '2025-01-01', '2025-12-31'),

-- Tarifs réduits (nuit)
(1.00, 'WEEKDAY', '22:00', '08:00', '2025-01-01', '2025-12-31');

-- ==========================
-- Table : Appliquer
-- ==========================
INSERT INTO appliquer (id_parking, id_tarif) VALUES
-- Parking 1 (Peixotto) - tous les tarifs
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),

-- Parking 2 (Forum) - tarifs standards
(2, 1), (2, 2), (2, 3), (2, 4),

-- Parking 3 (ENSEIRB) - tarifs réduits étudiants
(3, 2), (3, 6),

-- Parking 4 (Pessac) - tous les tarifs
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5),

-- Parking 5 (Gradignan) - tarifs standards
(5, 1), (5, 3), (5, 5);

-- ==========================
-- Table : Abonnement
-- ==========================
INSERT INTO abonnement (date_debut_abonnement, date_fin_abonnement, type_abonnement, tarif_mensuel_abonnement, id_vehicule) VALUES
('2025-01-01', '2025-12-31', 'Etudiant', 30.00, 4),
('2025-09-01', '2026-08-31', 'Etudiant', 30.00, 8),
('2025-01-01', '2025-12-31', 'Professeur', 50.00, 12),
('2025-06-01', '2026-05-31', 'Personnel', 40.00, 3),
('2025-01-01', '2025-12-31', 'Visiteur', 60.00, 7);