-- Warehouse Produits: id = 7
-- Warehouse Shipping: id = 5
-- Warehouse Raw: id = 1
-- Warehouse CN-BQC: id = 3
-- Warehouse CN-MISC: id = 12
-- Warehouse HK-FANCO: id = 11
-- Warehouse David: id = 14
-- Warehouse Demo: id = 4
-- Warehouse Octo: id = 15
-- Warehouse NAB22: id = 10
-- Warehouse Temp: id = 6
-- Warehouse R&D: id = 8
-- Warehouse Repair: id = 2
-- Warehouse Trash: id = 9
-- Warehouse Wanted: id = 13

CREATE VIEW llx_stockPerWarehouse AS
SELECT
  p.rowid AS Product,
  p.label AS Reference,
  SUM(CASE WHEN ps.fk_entrepot = 7 OR ps.fk_entrepot = 5 OR ps.fk_entrepot = 1 THEN ps.reel ELSE 0 END) AS ForSale,
  SUM(CASE WHEN ps.fk_entrepot = 7  THEN ps.reel ELSE 0 END) AS Produits,
  SUM(CASE WHEN ps.fk_entrepot = 5  THEN ps.reel ELSE 0 END) AS Shipping,
  SUM(CASE WHEN ps.fk_entrepot = 1  THEN ps.reel ELSE 0 END) AS Raw,
  SUM(CASE WHEN ps.fk_entrepot = 3  THEN ps.reel ELSE 0 END) AS BQC,
  SUM(CASE WHEN ps.fk_entrepot = 11 THEN ps.reel ELSE 0 END) AS Chine,
  SUM(CASE WHEN ps.fk_entrepot = 12 THEN ps.reel ELSE 0 END) AS Fanco,
  SUM(CASE WHEN ps.fk_entrepot = 8  THEN ps.reel ELSE 0 END) AS RD,
  SUM(CASE WHEN ps.fk_entrepot = 6  THEN ps.reel ELSE 0 END) AS Temp,
  SUM(CASE WHEN ps.fk_entrepot = 4  THEN ps.reel ELSE 0 END) AS Demo,
  SUM(CASE WHEN ps.fk_entrepot = 10 THEN ps.reel ELSE 0 END) AS NAB,
  SUM(CASE WHEN ps.fk_entrepot = 13 THEN ps.reel ELSE 0 END) AS Wanted,
  SUM(CASE WHEN ps.fk_entrepot = 14 THEN ps.reel ELSE 0 END) AS David,
  SUM(CASE WHEN ps.fk_entrepot = 15 THEN ps.reel ELSE 0 END) AS Octo,
  SUM(CASE WHEN ps.fk_entrepot = 2 THEN ps.reel ELSE 0 END) AS Repair,
  SUM(CASE WHEN ps.fk_entrepot = 9 THEN ps.reel ELSE 0 END) AS Trash,
  SUM(CASE WHEN ps.fk_entrepot NOT IN (1,2,3,4,5,6,7,8,9,11,12,13,14,15) THEN ps.reel ELSE 0 END) AS Unknown,
  SUM(CASE WHEN ps.fk_entrepot IN (1,2,3,4,5,6,7,8,9,11,12,13,14,15) THEN ps.reel ELSE 0 END) AS Total,
  p.cost_price AS UnitCost,
  SUM(CASE WHEN ps.fk_entrepot = 7 OR ps.fk_entrepot = 5 OR ps.fk_entrepot = 1 THEN ps.reel*p.cost_price ELSE 0 END) AS ToSaleCost,
  SUM(CASE WHEN ps.fk_entrepot IN (1,2,3,4,5,6,7,8,9,11,12,13,14,15) THEN ps.reel*p.cost_price ELSE 0 END) AS TotalCost
FROM  llx_product_stock AS ps
 LEFT JOIN llx_product as p ON p.rowid = ps.fk_product
 WHERE 1 = 1
 GROUP BY Product
 ORDER BY Reference;
 SELECT * FROM llx_stockPerWarehouse;
