-- Stock Variations
SELECT DATE_FORMAT(date(sm.datem),'%y-%m')  AS Month,
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
  FROM  llx_stock_mouvement AS sm
  LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
  WHERE sm.fk_entrepot IN (1,5,7)
GROUP BY Month
ORDER BY Month

-- Consumption
SELECT DATE_FORMAT(date(sm.datem),'%y-%m')  AS Month,
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
  FROM  llx_stock_mouvement AS sm
  LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
  WHERE (sm.fk_entrepot IN (1,5,7) AND sm.label LIKE 'Shipment%validated%')
GROUP BY Month
ORDER BY Month

-- Replenishment
SELECT DATE_FORMAT(date(sm.datem),'%y-%m')  AS Month,
  SUM(CASE WHEN p.accountancy_code_sell = 705010 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as RCP,
  SUM(CASE WHEN p.accountancy_code_sell = 705030 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as CI0,
  SUM(CASE WHEN p.accountancy_code_sell = 705032 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as RIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705020 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as GWY,
  SUM(CASE WHEN p.accountancy_code_sell = 705031 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as NIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705040 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as VP4,
  SUM(CASE WHEN p.accountancy_code_sell = 705060 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as ACC,
  SUM(CASE WHEN p.accountancy_code_sell = 705070 AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as LIC,
  SUM(CASE WHEN p.accountancy_code_sell IN (705000,705050,705080,705090) AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as MSC,
  SUM(CASE WHEN p.accountancy_code_sell NOT IN (705000,705010,705020,705030,705031,705032,705040,705050,705060,705070,705080,705090) AND (sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo') THEN sm.value ELSE 0 END) as TBD,
  SUM(CASE WHEN sm.label LIKE 'Reception%validated%' OR sm.origintype = 'mo' THEN sm.value ELSE 0 END) AS TOTAL
  FROM  llx_stock_mouvement AS sm
  LEFT JOIN llx_product as p ON p.rowid = sm.fk_product
  WHERE sm.fk_entrepot IN (1,5,7)
GROUP BY Month
ORDER BY Month
