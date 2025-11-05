
--  Liste des voitures par parking, la liste des parkings par commune
SELECT Parking.nom ,v.* From Stationnement s
JOIN Vehicule v ON v.num_immatriculation = s.num_immatriculation
JOIN Contenir c on c.id_place = s.id_place
JOIN Parking p on p.id_parking = c.id_parking

