-- fonctionne en utilisant fichier CSV (utf8), avec ou sans "", les virgules sont remplacées.
CRçEATE OR REPLACE VIEW ORDERFULL AS 
SELECT
    CONCAT("sorder",LPAD(c.rowid,5,0)) AS "External ID",
    c.ref AS "name",
    REPLACE(s.nom, ',','-') AS "customer",
    REPLACE(c.ref_client,',','_') AS "client_order_ref",
    CASE 
      WHEN s.remise_client = 0  THEN IF(s.fk_pays IN ("11","14"),"USD MSRP","EUR MSRP") 
      WHEN s.remise_client = 10 THEN IF(s.fk_pays IN ("11","14"),"USD Major","EUR Major") 
      WHEN s.remise_client > 10 THEN IF(s.fk_pays IN ("11","14"),"USD Reseller","EUR Reseller") 
      ELSE NULL
    END AS "pricelist_id/name",
    DATE_FORMAT(date(c.date_commande),'%Y-%m-%d') AS "date_order",
    IF(ISNULL(c.date_livraison), NULL, DATE_FORMAT(c.date_livraison, '%Y-%m-%d')) AS "commitment_date",
    IF(ISNULL(p.ref),"no product",p.ref) AS "product",
    -- IF(ISNULL(p.ref),"no product",CONCAT(first_line.ref," - [",p.label,"] ",p.ref)) AS "order_line/description",
    -- first_line.ref AS "produit2",
    REPLACE(CONCAT("[",p.label,"] ",p.ref), ',','-') AS "order_line/product_description", 
    IF(ISNULL(p.ref),"no product",p.ref) AS "order_line/product_id",

    "2" AS "order_line/customer_lead", 
    cd.qty AS "order_line/product_uom_qty",
    CEILING(cd.multicurrency_subprice) AS "order_line/price_unit", 
    cd.remise_percent AS "order_line/discount",
    sh.ref AS "ref_shipping",
    sh.tracking_number AS "tracking_num",
    shd.fk_origin_line AS "fk_ol"
    -- IF(ISNULL(c.date_livraison),"2019-07-01",DATE_FORMAT(date(c.date_livraison),'%Y-%m-%d')) AS "commitment_date",
FROM 
  -- Build an intermediate "first_line" table with the order id and the id of the first line of the order
  ( SELECT
        c.rowid AS orderId,
        c.ref   AS ref,
        MIN(cd.rowid) AS firstLineId
    FROM
  	  llx_commandedet AS cd 
  	  RIGHT JOIN llx_commande AS c ON c.rowid = cd.fk_commande			
    -- WHERE c.rowid IN (1,3) -- LIGHT RESULT
    WHERE 1 = 1 AND c.fk_soc <> 197  -- je vire 'BS Finland ay' et FULL RESULT
    GROUP BY c.rowid 
  ) AS first_line
  LEFT JOIN llx_commandedet AS cd ON cd.fk_commande = first_line.orderId
  LEFT JOIN llx_product     AS p ON p.rowid = cd.fk_product
  LEFT JOIN llx_commande    AS c ON first_line.firstLineId = cd.rowid AND c.rowid = first_line.orderId
  LEFT JOIN llx_societe     AS s ON s.rowid = c.fk_soc
  LEFT JOIN llx_expeditiondet AS shd ON shd.fk_origin_line = cd.rowid 
  LEFT JOIN llx_expedition AS sh ON sh.rowid = shd.fk_expedition 
  LEFT JOIN llx_expeditiondet_batch AS shdb ON shdb.fk_expeditiondet = shd.rowid
  /* LEFT JOIN llx_expedition AS sh ON sh.rowid = c.fk_expedition
  LEFT JOIN llx_expeditiondet AS shde ON sh.rowid = shde.fk_expedition
  
  -- LEFT JOIN llx_expedition_extrafields AS shxtra ON shxtra.rowid */ 
WHERE 1=1 AND cd.multicurrency_subprice <> 0 AND p.ref IS NOT NULL; -- erreur si un prix est à 0
SELECT * FROM ORDERFULL;