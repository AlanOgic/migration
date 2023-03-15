-- fonctionne en utilisant fichier CSV (utf8), avec ou sans "", les virgules sont remplacées.
CREATE OR REPLACE VIEW PURCHASEFULL AS 
SELECT
    CONCAT("porder",LPAD(po.rowid,5,0)) AS "External ID",
    po.ref AS "name",
    REPLACE(s.nom, ',','-') AS "supplier",
    REPLACE(po.ref_supplier,',','_') AS "supplier_order_ref",
    
    DATE_FORMAT(date(po.date_commande),'%Y-%m-%d') AS "date_order",
    DATE_FORMAT(date(po.date_livraison),'%Y-%m-%d') AS "date_livraison",
    DATE_FORMAT(date(rec.date_delivery),'%Y-%m-%d') AS "date_delivery",
    rec.tracking_number AS "trackink",
    rec.fk_statut AS "delivered",

    -- IF(ISNULL(po.date_livraison), DATE_FORMAT(DATE_ADD(po.date_commande, INTERVAL 5 DAY), '%Y-%m-%d'), DATE_FORMAT(po.date_livraison, '%Y-%m-%d')) AS "commitment_date",
    -- IF(ISNULL(po.date_livraison),DATE_FORMAT(DATE_ADD(day,po.date_commande,INTERVAL 10 DAY),'%Y-%m-%d'),DATE_FORMAT(date(po.date_livraison),'%Y-%m-%d')) AS "commitment_date",
    -- IF(ISNULL(p.ref),"no product",p.ref) AS "product",
    -- IF(ISNULL(p.ref),"no product",CONCAT(first_line.ref," - [",p.label,"] ",p.ref)) AS "order_line/description",
    -- first_line.ref AS "produit2",
    REPLACE(CONCAT("[",p.label,"] ",p.ref), ',','-') AS "order_line/product_description", 
    IF(ISNULL(p.ref),"no product",p.ref) AS "order_line/product_id",
    cd.qty AS "order_line/product_uom_qty",
    CEILING(cd.multicurrency_subprice) AS "order_line/price_unit", 
    cd.remise_percent AS "order_line/discount",
    IF(po.billed = 0,"no","invoiced") AS "bill_status",
    pd.batch AS "batch",
    pd.cost_price AS "cost price",
    pd.qty AS "dispatch qty",
    rec.note_private AS "private_note",
    rec.ref AS "recep_ref"
    -- IF(ISNULL(po.date_livraison),"2019-07-01",DATE_FORMAT(date(po.date_livraison),'%Y-%m-%d')) AS "commitment_date",
FROM 
  -- Build an intermediate "first_line" table with the order id and the id of the first line of the order
  ( SELECT
        po.rowid AS orderId,
        po.ref   AS ref,
        MIN(cd.rowid) AS firstLineId
    FROM
  	  llx_commande_fournisseurdet AS cd 
  	  RIGHT JOIN llx_commande_fournisseur AS po ON po.rowid = cd.fk_commande			
    -- WHERE po.rowid IN (1,3) -- LIGHT RESULT
    WHERE 1 = 1 AND po.fk_soc <> 197  -- je vire 'BS Finland ay' et FULL RESULT
    GROUP BY po.rowid 
  ) AS first_line
  LEFT JOIN llx_commande_fournisseurdet AS cd ON cd.fk_commande = first_line.orderId
  LEFT JOIN llx_product AS p ON p.rowid = cd.fk_product
  LEFT JOIN llx_commande_fournisseur  AS po ON first_line.firstLineId = cd.rowid AND po.rowid = first_line.orderId
  LEFT JOIN llx_societe AS s ON s.rowid = po.fk_soc
  LEFT JOIN llx_commande_fournisseur_dispatch AS pd ON po.rowid = pd.fk_commande 
  LEFT JOIN llx_reception AS rec ON rec.rowid = pd.fk_reception
WHERE 1=1 AND cd.multicurrency_subprice <> 0 AND p.ref IS NOT NULL; -- erreur si un prix est à 0
SELECT * FROM PURCHASEFULL;