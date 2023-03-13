CREATE OR REPLACE VIEW d1_wh AS 
SELECT
  CONCAT("whouse",LPAD(wh.rowid,4,0)) AS "External ID",
  wh.ref AS "Name",
  wh.description AS "description",
  wh.lieu AS "wh"
FROM
  llx_entrepot AS wh
WHERE 1
GROUP BY wh.rowid;
SELECT * FROM `d1_wh`