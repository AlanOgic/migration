-- INVOICES AMOUNT PER CUSTOMER CATEGORY PER MONTH
-- Getting invoice aggregate from lines of invoice (check purposes)
SELECT
  DATE_FORMAT(date(f.datef),'%y-%m')  AS Month,
  SUM(CASE WHEN cs.fk_categorie = 37 THEN f.total_ht ELSE 0 END) as ProAV,
  SUM(CASE WHEN cs.fk_categorie = 158 THEN f.total_ht ELSE 0 END) as OB,
  SUM(CASE WHEN cs.fk_categorie = 159 THEN f.total_ht ELSE 0 END) as Specialtist,
  SUM(CASE WHEN cs.fk_categorie = 162 THEN f.total_ht ELSE 0 END) as Others,
  SUM(CASE WHEN cs.fk_categorie = 235 THEN f.total_ht ELSE 0 END) as Unknown,
  SUM(CASE WHEN cs.fk_categorie NOT IN (37,158,159,162,235) THEN f.total_ht ELSE 0 END) as Unclassified,
  -- SUM(CASE WHEN cs.fk_categorie = 37 AND s.fk_pays = 1 THEN f.total_ht ELSE 0 END) as ProAV_FR,
  SUM(f.total_ht) AS TOTAL
FROM
  llx_societe AS s
  LEFT JOIN llx_facture AS f ON f.fk_soc = s.rowid
  LEFT JOIN llx_categorie_societe AS cs ON cs.fk_soc = s.rowid
  LEFT JOIN llx_categorie AS c ON c.rowid = cs.fk_categorie
  LEFT JOIN llx_categorie AS cbis ON cbis.rowid = c.fk_parent
WHERE f.datef IS NOT NULL AND f.datef > "2019-06-30" AND cbis.rowid = 157
GROUP BY Month
ORDER BY Month

-- Getting segment amount directly through tags
SELECT
 DATE_FORMAT(date(f.datef),'%y-%m')  AS Month,
 c.label AS Category,
 SUM(f.total_ht) AS Amount
 FROM  llx_societe AS s
 LEFT JOIN llx_facture AS f ON f.fk_soc = s.rowid
 LEFT JOIN llx_categorie_societe AS cs ON cs.fk_soc = s.rowid
 LEFT JOIN llx_categorie AS c ON c.rowid = cs.fk_categorie
 LEFT JOIN llx_categorie AS cbis ON cbis.rowid = c.fk_parent
 WHERE f.datef IS NOT NULL  AND f.datef > "2019-06-30" AND cbis.label LIKE 'Buyer'
 GROUP BY Month,Category
 ORDER BY Month,Category


-- INVOICES AMOUNT PER ACTIVITY(Added Value) PER MONTH
-- Getting invoice aggregate from lines of invoice (check purposes)
SELECT
  DATE_FORMAT(date(f.datef),'%y-%m')  AS Month,
  SUM(CASE WHEN cs.fk_categorie = 52 THEN f.total_ht ELSE 0 END) as Producer,
  SUM(CASE WHEN cs.fk_categorie = 42 THEN f.total_ht ELSE 0 END) as Technical Means,
  SUM(CASE WHEN cs.fk_categorie = 40 THEN f.total_ht ELSE 0 END) as Integrator,
  SUM(CASE WHEN cs.fk_categorie = 46 THEN f.total_ht ELSE 0 END) as Renter,
  SUM(CASE WHEN cs.fk_categorie = 47 THEN f.total_ht ELSE 0 END) as Reseller,
  SUM(CASE WHEN cs.fk_categorie = 200 THEN f.total_ht ELSE 0 END) as Manufacturer,
  SUM(CASE WHEN cs.fk_categorie = 201 THEN f.total_ht ELSE 0 END) as Others,
  SUM(CASE WHEN cs.fk_categorie = 234 THEN f.total_ht ELSE 0 END) as Unknown,
  SUM(CASE WHEN cs.fk_categorie NOT IN (52,42,40,46,47,200,234) THEN f.total_ht ELSE 0 END) as Unclassified,
  -- SUM(CASE WHEN cs.fk_categorie = 37 AND s.fk_pays = 1 THEN f.total_ht ELSE 0 END) as ProAV_FR,
  SUM(f.total_ht) AS TOTAL
FROM
  llx_societe AS s
  LEFT JOIN llx_facture AS f ON f.fk_soc = s.rowid
  LEFT JOIN llx_categorie_societe AS cs ON cs.fk_soc = s.rowid
  LEFT JOIN llx_categorie AS c ON c.rowid = cs.fk_categorie
  LEFT JOIN llx_categorie AS cbis ON cbis.rowid = c.fk_parent
WHERE f.datef IS NOT NULL AND f.datef > "2019-06-30" AND cbis.rowid = 39 -- Activity
GROUP BY Month
ORDER BY Month



-- COHERENCY CHECKS

-- Test de cohérence:
-- Sociétés étant OB ET ProAV mais pas revendeur
-- Getting invoice aggregate from lines of invoice (check purposes)
SELECT
  s.nom AS Societe,
  c_a.label AS OB,
  c_b.label AS ProAV,
  c_d.Label AS Added_Value,
  c_c.label AS Reseller
FROM
  llx_societe AS s
  LEFT JOIN llx_categorie_societe AS cs_a ON cs_a.fk_soc = s.rowid
  LEFT JOIN llx_categorie AS c_a ON cs_a.fk_categorie  = c_a.rowid
  LEFT JOIN llx_categorie_societe AS cs_b ON cs_b.fk_soc = s.rowid
  LEFT JOIN llx_categorie AS c_b ON cs_b.fk_categorie = c_b.rowid
  LEFT JOIN llx_categorie_societe AS cs_c ON cs_c.fk_soc = s.rowid
  LEFT JOIN llx_categorie AS c_c ON cs_c.fk_categorie = c_c.rowid
  LEFT JOIN llx_categorie AS c_d ON c_d.rowid = c_c.fk_parent
WHERE c_a.label LIKE '%OB%' AND c_b.label LIKE '%ProAV%' AND c_d.label LIKE '%Added Value%' AND c_c.label NOT LIKE '%Reseller%'

-- Test de cohérence:
-- Sociétés n'ayant aucun tag de type segment spécifié (Pro-AV = 37, OB=158,Specialtist = 159)
-- Getting invoice aggregate from lines of invoice (check purposes)
SELECT
  s.nom AS Customer,
  cs_a.fk_categorie AS Pro_AV ,
  cs_b.fk_categorie AS OB
FROM
  llx_societe AS s
  LEFT JOIN llx_categorie_societe AS cs_a ON cs_a.fk_soc = s.rowid AND cs_a.fk_categorie = 37
  LEFT JOIN llx_categorie_societe AS cs_b ON cs_b.fk_soc = s.rowid AND cs_b.fk_categorie = 159
WHERE s.client in (1,2,3) AND (cs_a.fk_categorie is NOT NULL) AND (cs_b.fk_categorie is NOT NULL)
ORDER BY Customer

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
