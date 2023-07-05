/* on ne peut pas importer une correction de stock pour les consommables ni les services (vérifier comment les produits sont catégorisés)
Ici j'isole les CBL car produits
*/

CREATE OR REPLACE VIEW X2_stock_CBL AS 
SELECT
  CONCAT("produc", LPAD(p.rowid, 4, 0)) AS "product/External ID",
  p.label AS "Internal Reference",
  p.ref AS "Name",
  pstock.reel AS "stock_reel_WH",
  p.fk_product_type AS "service"
FROM llx_product AS p
LEFT JOIN llx_product_stock AS pstock ON pstock.fk_product = p.rowid
LEFT JOIN llx_entrepot AS e ON pstock.fk_entrepot = e.rowid
LEFT JOIN llx_product_batch AS pb ON pb.fk_product_stock = pstock.rowid
WHERE pstock.reel > 0 AND pb.batch IS NULL AND p.ref LIKE 'CY-CBL%'
GROUP BY p.rowid, p.label, p.ref, pstock.reel;
SELECT * FROM X2_stock_CBL