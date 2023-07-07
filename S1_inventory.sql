CREATE OR REPLACE VIEW s1_inventory AS 
SELECT
  IF (pb.batch = 'CY-GWY-RAW', 'RAW-GWY',p.label) AS default_code,
  IF (pb.batch = 'CY-GWY-RAW', 'RAW-GWY',p.ref)   AS product_name,
  pstock.reel AS quantity_warehouse,
  e.ref       AS location_name,
  IF (pb.batch = 'CY-GWY-RAW', NULL, pb.batch)    AS serial_name,
  IF (pb.batch = 'CY-GWY-RAW', NULL, pb.qty)       AS quantity_lot
FROM llx_product AS p
LEFT JOIN llx_product_stock AS pstock ON pstock.fk_product = p.rowid
LEFT JOIN llx_entrepot      AS e      ON pstock.fk_entrepot = e.rowid
LEFT JOIN llx_product_batch AS pb     ON pb.fk_product_stock = pstock.rowid
WHERE pstock.reel <> 0 AND (pb.qty > 0 OR pb.batch IS NULL) ; 
SELECT * FROM s1_inventory;
