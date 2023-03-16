-- RCPs from from llx_stock_mouvements by month
SELECT
  DATE_FORMAT(sm.datem,"%y-%m") AS Month,
  p.ref as Product,
  p.rowid as Product_Id,
  SUM(CASE WHEN sm.fk_entrepot IN (1,5,7) THEN sm.value ELSE 0 END) AS ForSalesVar,
  SUM(CASE WHEN sm.fk_entrepot IN (1,5,7) AND sm.label LIKE 'Shipment%validated%' THEN sm.value ELSE 0 END) AS Consumption,
  SUM(CASE WHEN sm.fk_entrepot IN (1,5,7) AND sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo'  THEN sm.value ELSE 0 END) AS Replenishment,
  SUM(CASE WHEN sm.fk_entrepot IN (1,5,7) AND ((sm.label LIKE 'Shipment%validated%') OR  sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo' )THEN 0 ELSE sm.value END) AS Internal
FROM llx_stock_mouvement AS sm
LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
-- WHERE p.ref LIKE "%RCP%"
WHERE 1 = 1
GROUP BY Month,Product,Product_Id
ORDER BY Month,Product,Product_Id

-- Consumption by product type
SELECT
  DATE_FORMAT(sm.datem,"%y-%m") AS Month,
  SUM(CASE WHEN p.accountancy_code_sell = 705010 THEN sm.value ELSE 0 END) as RCP,
  SUM(CASE WHEN p.accountancy_code_sell = 705030 THEN sm.value ELSE 0 END) as CI0,
  SUM(CASE WHEN p.accountancy_code_sell = 705032 THEN sm.value ELSE 0 END) as RIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705020 THEN sm.value ELSE 0 END) as GWY,
  SUM(CASE WHEN p.accountancy_code_sell = 705031 THEN sm.value ELSE 0 END) as NIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705040 THEN sm.value ELSE 0 END) as VP4,
  SUM(CASE WHEN p.accountancy_code_sell = 705060 THEN sm.value ELSE 0 END) as ACC,
  SUM(CASE WHEN p.accountancy_code_sell = 705070 THEN sm.value ELSE 0 END) as LIC,
  SUM(CASE WHEN p.accountancy_code_sell IN (705000,705050,705080,705090) THEN sm.value ELSE 0 END) as MSC,
  SUM(CASE WHEN p.accountancy_code_sell NOT IN (705000,705010,705020,705030,705031,705032,705040,705050,705060,705070,705080,705090) THEN sm.value ELSE 0 END) as TBD,
  SUM(sm.value) AS TOTAL
FROM llx_stock_mouvement AS sm
LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
WHERE (sm.fk_entrepot IN (1,5,7) AND sm.label LIKE 'Shipment%validated%')
GROUP BY Month
ORDER BY Month
