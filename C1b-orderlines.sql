/*uniquement les orderlines */
CREATE OR REPLACE VIEW e1a_detailcom AS
SELECT 
  CONCAT("orline",LPAD(cd.rowid,4,0)) as "External ID",
  -- c.ref AS "ordername",
 -- Order Lines
  CONCAT("[",p.label,"] ",p.ref) AS "order_line/product",
  cd.remise_percent AS "order_line/discount",
  cd.qty AS "order_line/product_uom_qty",
  cd.multicurrency_subprice AS "order_line/price_unit",
  IF(ISNULL(cd.fk_product),"TRUE","FALSE") AS "order_line/is_expense",
  s.nom AS "partner",
  CONCAT("compan",LPAD(c.fk_soc,4,0)) AS "partner External ID",
  CONCAT("sorder",LPAD(c.rowid,4,0)) AS "order External ID",
  CONCAT("produc",LPAD(cd.fk_product,4,0)) AS "product External ID"
FROM llx_commandedet AS cd 
RIGHT JOIN llx_commande AS c ON cd.fk_commande = c.rowid
LEFT JOIN llx_product AS p ON cd.fk_product = p.rowid
LEFT JOIN llx_societe AS s ON c.fk_soc = s.rowid
WHERE 1 = 1;
SELECT * FROM e1a_detailcom;