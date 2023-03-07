/* Generate Odoo Price Lists from Dolibarr Pricelist exluding prices not in Dolibarr price list */
CREATE OR REPLACE VIEW b3_pricelists AS 
(
SELECT
    header.a AS "External Id",
    header.b AS "Pricelist Name",
    header.c AS "Currency",
    header.selectable AS "selectable",
    header.discount_policy AS "discount_policy",
    header.base_pricelist AS "item_ids/base_pricelist_id",
    "Product" AS "Pricelist Items/Apply On",
    "Fixed Price" AS "Pricelist Items/Compute Price",
    "Sales Price" AS "Pricelist Items/Based on",
    CONCAT("[",p.label,"] ",p.ref) AS "Pricelist Items/Product",
    -- USD value is always higher than 
    MAX(pp.price) AS "Pricelist Items/Fixed Price",
    0 AS "item_ids/price_discount"
  FROM
    (SELECT 
    "usd_msrp"    AS a,
    "USD MSRP"    AS b,
    "USD"         AS c,
    TRUE          AS selectable,
    "Discount included in the price" AS discount_policy,
    ""            AS base_pricelist,
    110 AS pivot) AS header  -- first p.rowid product wiht price_level 4
    RIGHT JOIN llx_product AS p ON p.rowid = header.pivot
    LEFT JOIN llx_product_price AS pp ON p.rowid = pp.fk_product AND (pp.price_level IN(4))
  WHERE p.tobuy = 1 OR p.tosell = 1 -- FULL EXPORT
  GROUP BY p.rowid
  HAVING MAX(pp.date_price)
)
UNION SELECT
    header.a AS "External Id",
    header.b AS "Pricelist Name",
    header.c AS "Currency",
    header.selectable AS "selectable",
    header.discount_policy AS "discount_policy",
    header.base_pricelist AS "item_ids/base_pricelist_id",
    "Product" AS "Pricelist Items/Apply On",
    "Fixed Price" AS "Pricelist Items/Compute Price",
    "Sales Price" AS "Pricelist Items/Based on",
    CONCAT("[",p.label,"] ",p.ref) AS "Pricelist Items/Product",
    -- USD value is always higher than 
    MAX(pp.price) AS "Pricelist Items/Fixed Price",
    0 AS "item_ids/price_discount"
  FROM
    (SELECT 
    "eur_msrp"    AS a,
    "EUR MSRP"    AS b,
    "EUR"         AS c,
    TRUE          AS selectable,
    "Discount included in the price" AS discount_policy,
    ""            AS base_pricelist,
    109 AS pivot) AS header  -- first p.rowid product wiht price_level 3
    RIGHT JOIN llx_product AS p ON p.rowid = header.pivot
    LEFT JOIN llx_product_price AS pp ON p.rowid = pp.fk_product AND (pp.price_level IN(3))
  WHERE p.tobuy = 1 OR p.tosell = 1 -- FULL EXPORT
  GROUP BY p.rowid
  HAVING MAX(pp.date_price)

  -- EUR Major pricelist
  UNION SELECT
    "eur_major" AS "External Id",
    "EUR Major" AS "Pricelist Name",
    "EUR" AS "Currency",
    TRUE AS "selectable",
    "Show public price & discount to the customer"  AS "discount_policy",
    "EUR MSRP" AS "item_ids/base_pricelist_id",
    "All Products" AS "Pricelist Items/Apply On",
    "Formula" AS "Pricelist Items/Compute Price",
    "Other Pricelist" AS "Pricelist Items/Based on",
    "All Products"AS "Pricelist Items/Product",
    0.0 AS "Pricelist Items/Fixed Price",
    10.0 AS "item_ids/price_discount"
  -- EUR Reseller pricelist
  UNION SELECT
    "eur_reseller" AS "External Id",
    "EUR Reseller" AS "Pricelist Name",
    "EUR" AS "Currency",
    TRUE AS "selectable",
    "Show public price & discount to the customer"  AS "discount_policy",
    "EUR MSRP" AS "item_ids/base_pricelist_id",
    "All Products" AS "Pricelist Items/Apply On",
    "Formula" AS "Pricelist Items/Compute Price",
    "Other Pricelist" AS "Pricelist Items/Based on",
    "All Products"AS "Pricelist Items/Product",
    0.0 AS "Pricelist Items/Fixed Price",
    20.0 AS "item_ids/price_discount"

    -- USD Major pricelist
  UNION SELECT
    "usd_major" AS "External Id",
    "USD Major" AS "Pricelist Name",
    "USD" AS "Currency",
    TRUE AS "selectable",
    "Show public price & discount to the customer"  AS "discount_policy",
    "USD MSRP" AS "item_ids/base_pricelist_id",
    "All Products" AS "Pricelist Items/Apply On",
    "Formula" AS "Pricelist Items/Compute Price",
    "Other Pricelist" AS "Pricelist Items/Based on",
    "All Products"AS "Pricelist Items/Product",
    0.0 AS "Pricelist Items/Fixed Price",
    10.0 AS "item_ids/price_discount"
  -- USD Reseller pricelist
  UNION SELECT
    "usd_reseller" AS "External Id",
    "USD Reseller" AS "Pricelist Name",
    "USD" AS "Currency",
    TRUE AS "selectable",
    "Show public price & discount to the customer"  AS "discount_policy",
    "USD MSRP" AS "item_ids/base_pricelist_id",
    "All Products" AS "Pricelist Items/Apply On",
    "Formula" AS "Pricelist Items/Compute Price",
    "Other Pricelist" AS "Pricelist Items/Based on",
    "All Products"AS "Pricelist Items/Product",
    0.0 AS "Pricelist Items/Fixed Price",
    20.0 AS "item_ids/price_discount";
  
SELECT * FROM b3_pricelists; 
