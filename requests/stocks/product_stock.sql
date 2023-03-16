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

 -- Not fully solved to be modified
 set @stRCP := 0;
 set @stCI0 := 0;
 set @stRIO := 0;
 set @stGWY := 0;
 set @stNIO := 0;
 set @stVP4 := 0;
 set @stACC := 0;
 set @stLIC := 0;
 set @stMSC := 0;
 set @stTBD := 0;
 set @stTOTAL := 0;
 SELECT
   DATE_FORMAT(ps.tms,"%y-%m") AS Month,
     CASE WHEN p.accountancy_code_sell = 705010 THEN @stRCP := ps.reel ELSE @stRCP END as RCP,
     CASE WHEN p.accountancy_code_sell = 705030 THEN @stCI0 := ps.reel ELSE @stCI0 END as CI0,
     CASE WHEN p.accountancy_code_sell = 705032 THEN @stRIO := ps.reel ELSE @stRIO END as RIO,
     CASE WHEN p.accountancy_code_sell = 705020 THEN @stGWY := ps.reel ELSE @stGWY END as GWY,
     CASE WHEN p.accountancy_code_sell = 705031 THEN @stNIO := ps.reel ELSE @stNIO END as NIO,
     CASE WHEN p.accountancy_code_sell = 705040 THEN @stVP4 := ps.reel ELSE @stVP4 END as VP4,
     CASE WHEN p.accountancy_code_sell = 705060 THEN @stACC := ps.reel ELSE @stACC END as ACC,
     CASE WHEN p.accountancy_code_sell = 705070 THEN @stLIC := ps.reel ELSE @stLIC END as LIC,
     CASE WHEN p.accountancy_code_sell IN (705000,705050,705080,705090) THEN @stTBD := ps.reel ELSE @stTBD END as MSC,
     CASE WHEN p.accountancy_code_sell NOT IN (705000,705010,705020,705030,705031,705032,705040,705050,705060,705070,705080,705090) THEN @stTBD := ps.reel ELSE @stTBD END as TBD,
     @stTOTAL := SUM(ps.reel) AS TOTAL
 FROM  llx_product_stock AS ps
    LEFT JOIN llx_product as p ON p.rowid = ps.fk_product
  WHERE 1 = 1

/*
  Script for new warehouses 202206
*/
  SELECT
    CONCAT('=HYPERLINK("https://dolibarr.cyanview.ovh/product/card.php?id=',p.rowid,'","',p.ref,'")') AS PLink,
    p.label AS Label,
    p.cost_price AS UnitValue,
    SUM(CASE WHEN ps.fk_entrepot IN (1,5,7) THEN ps.reel*p.cost_price ELSE 0 END) AS ForSaleValue,
    SUM(CASE WHEN ps.fk_entrepot IN (3,11,12) THEN ps.reel*p.cost_price ELSE 0 END) AS ChinaWaresValue,
    SUM(CASE WHEN ps.fk_entrepot IN (7,5,1) THEN ps.reel ELSE 0 END) AS ForSaleValue,
    SUM(CASE WHEN ps.fk_entrepot IN (3,11,12) THEN ps.reel ELSE 0 END) AS ChinaWares,
    SUM(CASE WHEN ps.fk_entrepot = 7  THEN ps.reel ELSE 0 END) AS Products,
    SUM(CASE WHEN ps.fk_entrepot = 5  THEN ps.reel ELSE 0 END) AS Shipping,
    SUM(CASE WHEN ps.fk_entrepot = 1  THEN ps.reel ELSE 0 END) AS Raw,
    SUM(CASE WHEN ps.fk_entrepot = 3  THEN ps.reel ELSE 0 END) AS BQC,
    SUM(CASE WHEN ps.fk_entrepot = 11 THEN ps.reel ELSE 0 END) AS Fanco,
    SUM(CASE WHEN ps.fk_entrepot = 12 THEN ps.reel ELSE 0 END) AS Chine,
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
   GROUP BY p.rowid
   HAVING Total <> 0
   ORDER BY Label
