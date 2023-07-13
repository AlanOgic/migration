CREATE OR REPLACE VIEW sosh_link AS
SELECT s.nom AS Company,
        CONCAT("produc",LPAD(e.rowid,4,0)) AS "ship ext id",
        e.date_delivery AS Date,
        e.tms AS timstamp,
        e.date_creation AS datecrea,
        p.ref AS Product,
        pl.rowid AS Serial,
        pl.batch,
        e.ref AS Shipment,
        ed.qty  AS Qty,
        IF(pl.rowid IS NOT NULL, 1, cd.qty) AS qty2,
        e.tracking_number,
        shm.code AS modeSH,
        e.fk_statut,
        c.ref AS SOrder,
        c.fk_mode_reglement AS PayModeO,
        cp.libelle AS PaymentmMde
FROM        llx_expedition AS e
  LEFT JOIN llx_expeditiondet                 AS ed  ON e.rowid   = ed.fk_expedition
  LEFT JOIN llx_expeditiondet_batch           AS edb ON ed.rowid  = edb.fk_expeditiondet
  LEFT JOIN llx_c_shipment_mode               AS shm ON e.fk_shipping_method = shm.rowid
  LEFT JOIN llx_product_lot                   AS pl  ON pl.batch  = edb.batch
  LEFT JOIN llx_commandedet                   AS cd  ON cd.rowid  = ed.fk_origin_line
  LEFT JOIN llx_commande                      AS c   ON c.rowid   = cd.fk_commande
  LEFT JOIN llx_societe                       AS s   ON s.rowid   = c.fk_soc
  LEFT JOIN llx_product                       AS p   ON p.rowid   = cd.fk_product
  LEFT JOIN llx_c_paiement                    AS cp  ON cp.id     = c.fk_mode_reglement
WHERE p.ref IS NOT NULL AND e.fk_statut <> 9 -- AND c.fk_mode_reglement NOT IN (56, 54, 58, 61, 62) AND e.date_creation < '2023-07-01'
ORDER BY e.rowid ASC, ed.rowid ASC;

/* On ne prend que le derniers envois par SN, affichage du customer


SELECT 
product, 
--COUNT(DISTINCT batch) AS occurrence_count,
MAX(datecrea) AS ledernier,
MAX(Company) AS dernierclient,
batch as snum
FROM sosh_link
GROUP BY batch, Product
HAVING occurrence_count > 0;


*/