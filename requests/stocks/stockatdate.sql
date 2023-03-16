-- Target: compare stocks obtained from lx_product_stock (inventaire courant) and llx_stock_mouvement (invetaire à date déterminée)
SELECT
  CONCAT('=HYPERLINK("https://dolibarr.cyanview.ovh/product/card.php?id=',p.rowid,'","',p.ref,'")') AS PLink,
  p.Label AS Label,
  p.cost_price AS UnitValue,
  SUM(CASE WHEN sm.fk_entrepot IN (1,5,7)   THEN sm.value*p.cost_price ELSE 0 END) AS ForSaleValue,
  SUM(CASE WHEN sm.fk_entrepot IN (3,11,12) THEN sm.value*p.cost_price ELSE 0 END) AS ChinaWaresValue,
  SUM(CASE WHEN sm.fk_entrepot IN (1,5,7)   THEN sm.value ELSE 0 END) AS ForSale,
  SUM(CASE WHEN sm.fk_entrepot IN (3,11,12) THEN sm.value ELSE 0 END) AS ChinaWares,
  SUM(CASE WHEN sm.fk_entrepot = 7  THEN sm.value ELSE 0 END) AS Products,
  SUM(CASE WHEN sm.fk_entrepot = 5  THEN sm.value ELSE 0 END) AS Shipping,
  SUM(CASE WHEN sm.fk_entrepot = 1  THEN sm.value ELSE 0 END) AS Raw,
  SUM(CASE WHEN sm.fk_entrepot = 3  THEN sm.value ELSE 0 END) AS BQC,
  SUM(CASE WHEN sm.fk_entrepot = 11 THEN sm.value ELSE 0 END) AS Fanco,
  SUM(CASE WHEN sm.fk_entrepot = 12 THEN sm.value ELSE 0 END) AS Chine,
  SUM(CASE WHEN sm.fk_entrepot = 8  THEN sm.value ELSE 0 END) AS RD,
  SUM(CASE WHEN sm.fk_entrepot = 6  THEN sm.value ELSE 0 END) AS Temp,
  SUM(CASE WHEN sm.fk_entrepot = 4  THEN sm.value ELSE 0 END) AS Demo,
  SUM(CASE WHEN sm.fk_entrepot = 10 THEN sm.value ELSE 0 END) AS NAB,
  SUM(CASE WHEN sm.fk_entrepot = 13 THEN sm.value ELSE 0 END) AS Wanted,
  SUM(CASE WHEN sm.fk_entrepot = 14 THEN sm.value ELSE 0 END) AS David,
  SUM(CASE WHEN sm.fk_entrepot = 15 THEN sm.value ELSE 0 END) AS Octo,
  SUM(CASE WHEN sm.fk_entrepot = 2 THEN sm.value ELSE 0 END) AS Repair,
  SUM(CASE WHEN sm.fk_entrepot = 9 THEN sm.value ELSE 0 END) AS Trash,
  SUM(CASE WHEN sm.fk_entrepot NOT IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) THEN sm.value ELSE 0 END) AS Unknown,
  SUM(CASE WHEN sm.fk_entrepot     IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) THEN sm.value ELSE 0 END) AS Total
FROM llx_stock_mouvement AS sm
  LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
<<<<<<< HEAD
WHERE sm.datem < '2022-07-04' AND p.ref IS NOT NULL
=======
WHERE sm.datem <= '2022-07-03' AND p.ref IS NOT NULL
>>>>>>> 1a3c0d0aaad6c129f60b75907ed0066a3ecf6a4f
GROUP BY p.rowid
HAVING Total <> 0
ORDER BY Label
