SELECT
    CONCAT("sorder",LPAD(c.rowid,5,0)) AS "External ID",
    c.ref AS "name",
    REPLACE(s.nom, ',','-') AS "customer",
    -- IF(ISNULL(p.ref),"no product",p.ref) AS "product",
    -- IF(ISNULL(p.ref),"no product",CONCAT(first_line.ref," - [",p.label,"] ",p.ref)) AS "order_line/description",
    -- first_line.ref AS "produit2",
    REPLACE(CONCAT("[",p.label,"] ",p.ref), ',','-') AS "order_line/product_id",
    p.ref AS "order_line/product_id",
    "2" AS "order_line/customer_lead",
    cd.qty AS "order_line/product_uom_qty",
    CEILING(cd.multicurrency_subprice) AS "order_line/price_unit",
    cd.remise_percent AS "order_line/discount",
    c.ref_client AS "client_order_ref",
    DATE_FORMAT(date(c.date_commande),'%Y-%m-%d') AS "date_order",
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
    WHERE 1 = 1 AND c.fk_soc <> 197  -- FULL RESULT
    GROUP BY c.rowid 
  ) AS first_line
  LEFT JOIN llx_commandedet AS cd ON cd.fk_commande = first_line.orderId
  LEFT JOIN llx_product     AS p ON p.rowid = cd.fk_product
  LEFT JOIN llx_commande    AS c ON first_line.firstLineId = cd.rowid AND c.rowid = first_line.orderId
  LEFT JOIN llx_societe     AS s ON s.rowid = c.fk_soc
WHERE 1=1 AND cd.multicurrency_subprice <> 0 AND p.ref IS NOT NULL;
