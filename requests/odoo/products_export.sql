/* Generate Products for Odoo
  Use llx_product_price price with newer price when price_level 3 is defined, llx_product.price otherwise
*/
SELECT
  p.rowid AS "External ID",
  p.label AS "Internal Reference",
  p.ref   AS "Name",
  IF(p.tobuy = 0 AND p.tosell = 0,FALSE,TRUE) AS Active,
  p.tosell AS "Can be Sold",
  p.tobuy  AS "Can be Purchased",
  -- IFNULL(p.customcode,"") AS "HScode US",
  -- IFNULL(country.code,"") AS "Country of Origin",
  IFNULL(p.cost_price,0.0) AS Cost,
  -- "EUR" AS "Cost Currency",
  -- pp.price_level AS Level,
  MAX(IF(pp.price_level = 3, pp.price, p.price)) AS "Sales Price",
  -- "EUR" AS Currency,
  IF(p.fk_product_type = 0,"Storable Product","Service") AS "Product Type",
  GROUP_CONCAT(
      DISTINCT
      CASE
        WHEN c.rowid = 193 THEN "All / Obsolete"
        WHEN c.rowid IN (194,195,196) THEN CONCAT ("All / Saleable / ",c.label)
        WHEN c.rowid IN (197,198,199) THEN CONCAT ("All / Consumable / ",c.label)
        ELSE "All / Services"
      END
      SEPARATOR ',')
      AS "Product Category",
  IF(p.tobatch = 1,"By Unique Serial Number","No Tracking") AS Tracking,
  IFNULL(p.weight,0.0) AS Weight,
  -- "kg" AS "Weight unit of measure label",
  -- IFNULL(DATE_FORMAT(date(p.datec),'%Y-%m-%d'),"2019-07-01") AS "date",
  IFNULL(REPLACE(REPLACE(p.description,"<p>",""),"</p>",""),"") AS "Sales Description",
  IFNULL (IF(p.customcode="8529 90 65","8529 90 65 00",p.customcode),"8529 90 65 00") AS "HS Code",
  IFNULL (country.code,"BE") AS "Origin of Goods/Country Code"
  -- IFNULL(p.note,"") AS Comment
FROM llx_product AS p
LEFT JOIN llx_product_price     AS pp ON pp.fk_product = p.rowid
LEFT JOIN llx_categorie_product AS cp ON cp.fk_product = p.rowid
LEFT JOIN llx_categorie         AS c ON c.rowid = cp.fk_categorie
LEFT JOIN llx_c_country         AS country ON country.rowid = p.fk_country
-- WHERE 1 -- EUR-2023 prices
WHERE p.rowid IN (126,294,201,200,202,377,118,330,119,391)-- Limited
GROUP BY p.rowid
HAVING MAX(pp.date_price)
