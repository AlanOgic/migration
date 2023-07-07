CREATE OR REPLACE VIEW X2_stock AS 
SELECT
  CONCAT("produc", LPAD(p.rowid, 4, 0)) AS "product/External ID",
  p.label AS "Internal Reference",
  p.ref AS "Name",
  SUM(pstock.reel) AS "stock reel",
  e.ref AS "warehouse",
  pb.batch AS "serial",
  SUM(pb.qty) AS "qty"
FROM llx_product AS p
LEFT JOIN llx_product_stock AS pstock ON pstock.fk_product = p.rowid
LEFT JOIN llx_entrepot AS e ON pstock.fk_entrepot = e.rowid
LEFT JOIN llx_product_batch AS pb ON pb.fk_product_stock = pstock.rowid
WHERE 1 = 1
GROUP BY p.rowid, p.label, p.ref, e.ref, pb.batch,pb.qty;
SELECT * FROM X2_stock