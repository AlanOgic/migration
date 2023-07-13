CREATE OR REPLACE VIEW ORDERFULL AS 
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
    DATE_FORMAT(date(c.tms),'%Y-%m-%d') AS "date_order",
    REPLACE(CONCAT("[",p.label,"] ",p.ref), ',','-') AS "order_line/product_description", 
    IF(ISNULL(p.ref),"no product",p.ref) AS "order_line/product_id",
    e.ref AS Shipment,
    e.ref AS "transfers/name",
    e.date_delivery,
    e.tms,
    "Delivery Orders" AS "operation type",
    e.location_incoterms AS "incoterm location",
    e.tracking_number AS "transfers/tracking reference",
    e.billed,
    e.fk_statut AS "statut SH",
    edb.batch AS "transfers / operations / lot/serial number",
    s.address,
    c.ref as name2,
    c.ref as name3,
    s.nom as soc2,
    "WH/Stock" AS "transferts/source location",
    "Partners/Customers" AS "transferts/destination location",
    c.fk_statut AS "statut commande",
    "2" AS "order_line/customer_lead", 
    cd.qty AS "order_line/product_uom_qty",
    CEILING(cd.multicurrency_subprice) AS "order_line/price_unit", 
    cd.remise_percent AS "order_line/discount"
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
    WHERE 1 = 1 AND c.rowid > 1498 --c.fk_mode_reglement NOT IN (56, 54, 58, 61, 62)
    GROUP BY c.rowid 
  ) AS first_line
  LEFT JOIN llx_commandedet AS cd ON cd.fk_commande = first_line.orderId
  LEFT JOIN llx_expeditiondet AS ed ON ed.fk_origin_line = cd.rowid
  LEFT JOIN llx_expedition AS e ON e.rowid = ed.fk_expedition
  LEFT JOIN llx_expeditiondet_batch AS edb ON edb.fk_expeditiondet = ed.rowid
  LEFT JOIN llx_product     AS p ON p.rowid = cd.fk_product
  LEFT JOIN llx_commande    AS c ON first_line.firstLineId = cd.rowid AND c.rowid = first_line.orderId
  LEFT JOIN llx_societe     AS s ON s.rowid = c.fk_soc
WHERE 1=1 AND cd.multicurrency_subprice <> 0 AND p.ref IS NOT NULL AND e.ref IS NOT NULL; -- AND c.fk_mode_reglement; -- NOT IN (56, 54, 58, 61, 62); -- AND c.rowid > 1498; -- erreur si un prix est à 0
SELECT * FROM ORDERFULL;