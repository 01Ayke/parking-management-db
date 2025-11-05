
--  Liste des voitures par parking
SELECT p.nom ,v.* From Creneau cr
JOIN Vehicule v ON v.num_immatriculation = cr.num_immatriculation
JOIN Place pl on pl.id_place = cr.id_place
JOIN Parking p on p.id_parking = pl.id_parking

-- la liste des parkings par commune
SELECT c.nom as nom_commune ,p.* From Commune c
JOIN Parking p on p.id_commune = c.id_commune

-- Liste des places disponibles, par parking, à un moment donné
\set moment '15:00:00'

SELECT p.nom AS parking_nom, pl.id_place, pl.etat
FROM Place pl
JOIN Parking p ON p.id_parking=pl.id_parking
LEFT JOIN Creneau c ON s.id_place = pl.id_place
    AND :'moment' BETWEEN s.heure_debut AND s.heure_fin
WHERE s.id_stationnement IS NULL;
