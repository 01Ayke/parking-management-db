
-- ============================================================
--   On supprime d’abord les tables qui dépendent d’autres tables
--    (à cause des clés étrangères).
-- ============================================================

DROP TABLE IF EXISTS appliquer CASCADE;
DROP TABLE IF EXISTS creneau CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS parking CASCADE;
DROP TABLE IF EXISTS tarif CASCADE;
DROP TABLE IF EXISTS vehicule CASCADE;
DROP TABLE IF EXISTS commune CASCADE;

