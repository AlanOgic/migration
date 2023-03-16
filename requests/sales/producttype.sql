-- Sales/Invoices requests with Product Type (PType) as columns
-- Amount of invoices
SELECT DATE_FORMAT(date(f.datef),'%y-%m')  AS Month,
  SUM(CASE WHEN p.accountancy_code_sell = 705010 THEN fd.total_ht ELSE 0 END) as RCP,
  SUM(CASE WHEN p.accountancy_code_sell = 705030 THEN fd.total_ht ELSE 0 END) as CI0,
  SUM(CASE WHEN p.accountancy_code_sell = 705032 THEN fd.total_ht ELSE 0 END) as RIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705020 THEN fd.total_ht ELSE 0 END) as GWY,
  SUM(CASE WHEN p.accountancy_code_sell = 705031 THEN fd.total_ht ELSE 0 END) as NIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705040 THEN fd.total_ht ELSE 0 END) as VP4,
  SUM(CASE WHEN p.accountancy_code_sell = 705060 THEN fd.total_ht ELSE 0 END) as ACC,
  SUM(CASE WHEN p.accountancy_code_sell = 705080 THEN fd.total_ht ELSE 0 END) as DEV,
  SUM(CASE WHEN p.accountancy_code_sell = 705070 THEN fd.total_ht ELSE 0 END) as LIC,
  SUM(CASE WHEN p.accountancy_code_sell = 705050 THEN fd.total_ht ELSE 0 END) as RES,
  SUM(CASE WHEN p.accountancy_code_sell IN (705000,705090) THEN fd.total_ht ELSE 0 END) as MSC,
  SUM(CASE WHEN p.accountancy_code_sell NOT IN (705000,705010,705020,705030,705031,705032,705040,705050,705060,705070,705080,705090) THEN fd.total_ht ELSE 0 END) as TBD,
  SUM(fd.total_ht) AS TOTAL
FROM  llx_facture AS f
LEFT JOIN llx_facturedet AS fd ON f.rowid = fd.fk_facture
LEFT JOIN llx_product AS p ON p.rowid = fd.fk_product
WHERE f.datef > '2019-05-31'
GROUP BY Month
ORDER BY Month

-- Sales/Invoices requests with Product Type (PType) as columns
-- Quantity of products
SELECT DATE_FORMAT(date(f.datef),'%y-%m')  AS Month,
  SUM(CASE WHEN p.accountancy_code_sell = 705010 THEN fd.qty ELSE 0 END) as RCP,
  SUM(CASE WHEN p.accountancy_code_sell = 705030 THEN fd.qty ELSE 0 END) as CI0,
  SUM(CASE WHEN p.accountancy_code_sell = 705032 THEN fd.qty ELSE 0 END) as RIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705020 THEN fd.qty ELSE 0 END) as GWY,
  SUM(CASE WHEN p.accountancy_code_sell = 705031 THEN fd.qty ELSE 0 END) as NIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705040 THEN fd.qty ELSE 0 END) as VP4,
  SUM(CASE WHEN p.accountancy_code_sell = 705060 THEN fd.qty ELSE 0 END) as ACC,
  SUM(CASE WHEN p.accountancy_code_sell = 705080 THEN fd.qty ELSE 0 END) as DEV,
  SUM(CASE WHEN p.accountancy_code_sell = 705070 THEN fd.qty ELSE 0 END) as LIC,
  SUM(CASE WHEN p.accountancy_code_sell = 705050 THEN fd.qty ELSE 0 END) as RES,
  SUM(CASE WHEN p.accountancy_code_sell IN (705000,705090) THEN fd.qty ELSE 0 END) as MSC,
  SUM(CASE WHEN p.accountancy_code_sell NOT IN (705000,705010,705020,705030,705031,705032,705040,705050,705060,705070,705080,705090) THEN fd.qty ELSE 0 END) as TBD,
  SUM(fd.qty) AS TOTAL
FROM  llx_facture AS f
LEFT JOIN llx_facturedet AS fd ON f.rowid = fd.fk_facture
LEFT JOIN llx_product AS p ON p.rowid = fd.fk_product
WHERE f.datef > '2019-05-31'
GROUP BY Month
ORDER BY Month

-- Sales/Invoices requests with Product Type (PType) as columns
-- Costs of products
SELECT DATE_FORMAT(date(f.datef),'%y-%m')  AS Month,
  SUM(CASE WHEN p.accountancy_code_sell = 705010 THEN fd.qty * p.cost_price ELSE 0 END) as RCP,
  SUM(CASE WHEN p.accountancy_code_sell = 705030 THEN fd.qty * p.cost_price ELSE 0 END) as CI0,
  SUM(CASE WHEN p.accountancy_code_sell = 705032 THEN fd.qty * p.cost_price ELSE 0 END) as RIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705020 THEN fd.qty * p.cost_price ELSE 0 END) as GWY,
  SUM(CASE WHEN p.accountancy_code_sell = 705031 THEN fd.qty * p.cost_price ELSE 0 END) as NIO,
  SUM(CASE WHEN p.accountancy_code_sell = 705040 THEN fd.qty * p.cost_price ELSE 0 END) as VP4,
  SUM(CASE WHEN p.accountancy_code_sell = 705060 THEN fd.qty * p.cost_price ELSE 0 END) as ACC,
  SUM(CASE WHEN p.accountancy_code_sell = 705080 THEN fd.qty * p.cost_price ELSE 0 END) as DEV,
  SUM(CASE WHEN p.accountancy_code_sell = 705070 THEN fd.qty * p.cost_price ELSE 0 END) as LIC,
  SUM(CASE WHEN p.accountancy_code_sell = 705050 THEN fd.qty * p.cost_price ELSE 0 END) as RES,
  SUM(CASE WHEN p.accountancy_code_sell IN (705000,705090) THEN fd.qty * p.cost_price ELSE 0 END) as MSC,
  SUM(CASE WHEN p.accountancy_code_sell NOT IN (705000,705010,705020,705030,705031,705032,705040,705050,705060,705070,705080,705090) THEN fd.qty * p.cost_price ELSE 0 END) as TBD,
  SUM(fd.qty * p.cost_price) AS TOTAL
FROM  llx_facture AS f
LEFT JOIN llx_facturedet AS fd ON f.rowid = fd.fk_facture
LEFT JOIN llx_product AS p ON p.rowid = fd.fk_product
WHERE f.datef > '2019-05-31'
GROUP BY Month
ORDER BY Month
