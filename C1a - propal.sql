CREATE OR REPLACE VIEW C1a_propale AS 
SELECT
  CONCAT("propal",LPAD(pr.rowid,4,0)) AS "External ID",
  st.id AS "statut_external_id",
  pr.ref AS "name",
  CONCAT("compan",LPAD(pr.fk_soc,4,0)) AS "partner external id",
  DATE_FORMAT(date(pr.datep),'%Y-%m-%d') AS "date_propal",
  DATE_FORMAT(date(pr.datec),'%Y-%m-%d') AS "date_creation",
  DATE_FORMAT(date(pr.date_livraison),'%Y-%m-%d') AS "commitment_date",
  DATE_FORMAT(date(pr.date_cloture),'%Y-%m-%d') AS "closing_date",
  pr.note_private AS "private_note",
  pr.note_public AS "public_note",
  pr.total_ttc AS "prixTTC",
  pr.fk_multicurrency AS "currency",
  pr.multicurrency_code AS "currency_code",
  pr.multicurrency_total_ttc AS "multicurrency_ttc",
CASE
   WHEN st.id = 0 THEN "Draft"
   WHEN st.id = 1 THEN "Sent"
   WHEN st.id = 2 THEN "Sale"
   WHEN st.id = 3 THEN "Done"
   WHEN st.id = 4 THEN "Cancel"
  END AS "state"
FROM llx_propal AS pr
LEFT JOIN status AS st ON pr.fk_statut = st.id
WHERE 1=1;
SELECT * FROM C1a_propale;