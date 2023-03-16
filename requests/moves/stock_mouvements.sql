--COMPARE RESULTS FROMT TABLES llx_product_stock and llx_stock_mouvement

-- RCPs from from llx_stock_mouvements
SELECT
  p.rowid AS Product,
  p.ref AS Reference,
  SUM(CASE WHEN sm.fk_entrepot = 7 OR sm.fk_entrepot = 5 OR sm.fk_entrepot = 1 THEN sm.value ELSE 0 END) AS ForSale,
  SUM(CASE WHEN sm.fk_entrepot = 7 THEN sm.value ELSE 0 END) AS Produits,
  SUM(CASE WHEN sm.fk_entrepot = 5 THEN sm.value ELSE 0 END) AS Shipping,
  SUM(CASE WHEN sm.fk_entrepot = 1 THEN sm.value ELSE 0 END) AS Raw,
  SUM(CASE WHEN sm.fk_entrepot = 8 THEN sm.value ELSE 0 END) AS R_D,
  SUM(CASE WHEN sm.fk_entrepot = 4 THEN sm.value ELSE 0 END) AS Demo,
  SUM(CASE WHEN sm.fk_entrepot = 3 THEN sm.value ELSE 0 END) AS Chine,
  SUM(CASE WHEN sm.fk_entrepot = 2 THEN sm.value ELSE 0 END) AS Repair,
  SUM(CASE WHEN sm.fk_entrepot = 6 THEN sm.value ELSE 0 END) AS Temporary,
  SUM(CASE WHEN sm.fk_entrepot = 9 THEN sm.value ELSE 0 END) AS Trash
FROM llx_stock_mouvement AS sm
  LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
-- WHERE p.ref LIKE "%RCP%"
WHERE p.ref IN ("CY-RCP","CY-RCP-DUO", "CY-RCP-QUATTRO", "CY-RCP-OCTO","RAW-RCP")
GROUP BY Product
ORDER BY Reference

-- RCPs from from llx_product_stock
SELECT
  p.rowid AS Product,
  p.ref AS Reference,
  SUM(CASE WHEN ps.fk_entrepot = 7 OR ps.fk_entrepot = 5 OR ps.fk_entrepot = 1 THEN ps.reel ELSE 0 END) AS ForSale,
  SUM(CASE WHEN ps.fk_entrepot = 7 THEN ps.reel ELSE 0 END) AS Produits,
  SUM(CASE WHEN ps.fk_entrepot = 5 THEN ps.reel ELSE 0 END) AS Shipping,
  SUM(CASE WHEN ps.fk_entrepot = 1 THEN ps.reel ELSE 0 END) AS Raw,
  SUM(CASE WHEN ps.fk_entrepot = 8 THEN ps.reel ELSE 0 END) AS R_D,
  SUM(CASE WHEN ps.fk_entrepot = 4 THEN ps.reel ELSE 0 END) AS Demo,
  SUM(CASE WHEN ps.fk_entrepot = 3 THEN ps.reel ELSE 0 END) AS Chine,
  SUM(CASE WHEN ps.fk_entrepot = 2 THEN ps.reel ELSE 0 END) AS Repair,
  SUM(CASE WHEN ps.fk_entrepot = 6 THEN ps.reel ELSE 0 END) AS Temporary,
  SUM(CASE WHEN ps.fk_entrepot = 9 THEN ps.reel ELSE 0 END) AS Trash
FROM  llx_product_stock AS ps
 LEFT JOIN llx_product as p ON p.rowid = ps.fk_product
 WHERE p.ref IN ("CY-RCP","CY-RCP-DUO", "CY-RCP-QUATTRO", "CY-RCP-OCTO","RAW-RCP")
 GROUP BY Product
 ORDER BY Product;

 -- RCPs from from llx_stock_mouvements by month
 SELECT
   DATE_FORMAT(sm.datem,"%y-%m") AS Month,
   SUM(CASE WHEN sm.fk_entrepot = 7 OR sm.fk_entrepot = 5 OR sm.fk_entrepot = 1 THEN sm.value ELSE 0 END) AS ForSale,
   SUM(CASE WHEN sm.fk_entrepot = 7 THEN sm.value ELSE 0 END) AS Produits,
   SUM(CASE WHEN sm.fk_entrepot = 5 THEN sm.value ELSE 0 END) AS Shipping,
   SUM(CASE WHEN sm.fk_entrepot = 1 THEN sm.value ELSE 0 END) AS Raw,
   SUM(CASE WHEN sm.fk_entrepot = 8 THEN sm.value ELSE 0 END) AS R_D,
   SUM(CASE WHEN sm.fk_entrepot = 4 THEN sm.value ELSE 0 END) AS Demo,
   SUM(CASE WHEN sm.fk_entrepot = 3 THEN sm.value ELSE 0 END) AS Chine,
   SUM(CASE WHEN sm.fk_entrepot = 2 THEN sm.value ELSE 0 END) AS Repair,
   SUM(CASE WHEN sm.fk_entrepot = 6 THEN sm.value ELSE 0 END) AS Temporary,
   SUM(CASE WHEN sm.fk_entrepot = 9 THEN sm.value ELSE 0 END) AS Trash

 FROM llx_stock_mouvement AS sm
   LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
 -- WHERE p.ref LIKE "%RCP%"
 WHERE p.ref IN ("CY-RCP","CY-RCP-DUO", "CY-RCP-QUATTRO", "CY-RCP-OCTO","RAW-RCP")
 GROUP BY Month
 ORDER BY Month

-- AS google script ?...
SELECT
  DATE_FORMAT(sm.datem,"%y-%m") AS Month,
  SUM(sm.value) AS Qty
FROM llx_stock_mouvement AS sm
LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
WHERE p.rowid IN (200,202,203,278,234)
-- WHERE (p.ref IN ("CY-RCP","CY-RCP-DUO", "CY-RCP-QUATTRO", "CY-RCP-OCTO","RAW-RCP"))
      AND (YEAR(sm.datem) = 2020 AND MONTH(sm.datem) = 2)
      AND((sm.fk_entrepot=1) or (sm.fk_entrepot=5) or (sm.fk_entrepot=7))
GROUP BY Month
