
-- ========= Parameters =========
\set instant_ts '2025-12-04 10:30:00'
\set date_jour  '2025-12-04'

-- ========= 1a) Liste des voitures par parking =========
SELECT DISTINCT
    p.id_parking,
    p.nom_parking,
    v.id_vehicule,
    v.num_immatriculation
FROM stationnement s
JOIN place pl ON s.id_place = pl.id_place
JOIN parking p ON pl.id_parking = p.id_parking
JOIN vehicule v ON s.id_vehicule = v.id_vehicule
ORDER BY p.nom_parking, v.num_immatriculation;

-- ========= 1b) Liste des parkings par commune =========
SELECT
    c.id_commune,
    c.nom_commune,
    p.id_parking,
    p.nom_parking
FROM parking p
JOIN commune c ON p.id_commune = c.id_commune
ORDER BY c.nom_commune, p.nom_parking;

-- ========= 2) Parkings saturés à une date donnée (approx. journalière) =========
-- Hypothèse "saturation journalière": stationnement intersecte la date :date_jour
WITH places_par_parking AS (
    SELECT pl.id_parking, COUNT(*) AS nb_places
    FROM place pl
    GROUP BY pl.id_parking
),
stationnements_jour AS (
    SELECT
        pl.id_parking,
        s.id_stationnement
    FROM stationnement s
    JOIN place pl ON s.id_place = pl.id_place
    WHERE s.date_debut <= :'date_jour'::date
      AND s.date_fin   >= :'date_jour'::date
)
SELECT
    p.id_parking,
    p.nom_parking,
    p.capacite,
    COUNT(DISTINCT sj.id_stationnement) AS nb_stationnements_jour
FROM parking p
LEFT JOIN stationnements_jour sj ON sj.id_parking = p.id_parking
GROUP BY p.id_parking, p.nom_parking, p.capacite
HAVING COUNT(DISTINCT sj.id_stationnement) >= p.capacite
ORDER BY p.nom_parking;

-- ========= 3) Parkings saturés à l’instant :'instant_ts' =========
-- Version "end-of-day" pour NULL heure_fin/date_fin (ongoing = actif jusqu’à 23:59:59 du jour)
stationnements_intervalles AS (
    SELECT
        s.id_stationnement,
        s.id_place,
        (COALESCE(s.date_debut, s.date_fin)::timestamp
         + COALESCE(s.heure_debut::time, '00:00:00'::time)) AS ts_debut,
        (COALESCE(s.date_fin, s.date_debut)::timestamp
         + COALESCE(s.heure_fin::time, '23:59:59'::time))   AS ts_fin
    FROM stationnement s
),
places_occupees AS (
    SELECT DISTINCT si.id_place
    FROM stationnements_intervalles si
    WHERE :'instant_ts'::timestamp >= si.ts_debut
      AND :'instant_ts'::timestamp <  si.ts_fin
),
occupation_parking AS (
    SELECT pl.id_parking, COUNT(*) AS nb_places_occupees
    FROM places_occupees po
    JOIN place pl ON pl.id_place = po.id_place
    GROUP BY pl.id_parking
)
SELECT
    p.id_parking,
    p.nom_parking,
    p.capacite,
    op.nb_places_occupees AS nb_places_occupees
FROM parking p
LEFT JOIN occupation_parking op ON op.id_parking = p.id_parking
WHERE op.nb_places_occupees >= p.capacite
ORDER BY p.nom_parking;

-- ========= 4) Places disponibles par parking à :'instant_ts' =========
WITH stationnements_intervalles AS (
    SELECT
        s.id_stationnement,
        s.id_place,
        (s.date_debut::timestamp + s.heure_debut::time) AS ts_debut,
        (s.date_fin::timestamp + s.heure_fin::time) AS ts_fin
    FROM stationnement s
),
places_occupees AS (
    SELECT DISTINCT si.id_place
    FROM stationnements_intervalles si
    WHERE :'instant_ts'::timestamp >= si.ts_debut
      AND :'instant_ts'::timestamp <  si.ts_fin
)
SELECT
    p.id_parking,
    p.nom_parking,
    pl.id_place,
    pl.num_place
FROM place pl
JOIN parking p ON p.id_parking = pl.id_parking
WHERE NOT EXISTS (
  SELECT 1 FROM places_occupees po WHERE po.id_place = pl.id_place
)
ORDER BY p.nom_parking, pl.num_place;

-- ========= 5) Voitures garées dans ≥ 2 parkings le :date_jour =========
SELECT
    v.id_vehicule,
    v.num_immatriculation,
    COUNT(DISTINCT p.id_parking) AS nb_parkings_distincts
FROM stationnement s
JOIN place pl   ON s.id_place = pl.id_place
JOIN parking p  ON pl.id_parking = p.id_parking
JOIN vehicule v ON s.id_vehicule = v.id_vehicule
WHERE s.date_debut <= :'date_jour'::date
  AND s.date_fin   >= :'date_jour'::date
GROUP BY v.id_vehicule, v.num_immatriculation
HAVING COUNT(DISTINCT p.id_parking) >= 2
ORDER BY v.num_immatriculation;
