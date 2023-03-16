/*#############################################################################
-- VIEW DESCRIBING ALL THE INPUT (SHIPMENT) AND OUTPUT (RECEPTION) OF PRODUCTS
-- #############################################################################
-- MyLists module do not support SQL "UNION" command, so a VIEW is created for Mylists usage
-- Get items shipped and ordered wiht "loan" payment mode and plus items returned
-- The objective is to get a debit/credit in terms of products for each customers */
-- CREATE OR REPLACE VIEW llx_productsIO AS
SELECT s.rowid AS Company,
       e.date_delivery AS Date,
       p.rowid AS Product,
       pl.rowid AS Serial,
       pl.batch AS Batch,
       e.rowid AS Shipment,
       NUll  AS Reception,
       (ed.qty * -1)  AS Qty,
       c.rowid AS SOrder,
       c.fk_mode_reglement AS PayModeO,
       Null AS PayModeI
FROM        llx_expedition AS e
  LEFT JOIN llx_expeditiondet                 AS ed  ON e.rowid   = ed.fk_expedition
  LEFT JOIN llx_expeditiondet_batch           AS edb ON ed.rowid  = edb.fk_expeditiondet
  LEFT JOIN llx_product_lot                   AS pl  ON pl.batch  = edb.batch
  LEFT JOIN llx_commandedet                   AS cd  ON cd.rowid  = ed.fk_origin_line
  LEFT JOIN llx_commande                      AS c   ON c.rowid   = cd.fk_commande
  LEFT JOIN llx_societe                       AS s   ON s.rowid   = c.fk_soc
  LEFT JOIN llx_product                       AS p   ON p.rowid   = cd.fk_product
  LEFT JOIN llx_c_paiement                    AS cp  ON cp.id     = c.fk_mode_reglement
WHERE p.ref IS NOT NULL
UNION (
  SELECT s.rowid AS Company,
         r.date_creation AS Date,
         p.rowid AS Product,
         pl.rowid AS Serial,
         pl.batch AS Batch,
         Null AS Shipment,
         r.rowid AS Reception,
         cfd.qty AS Qty,
         Null AS SOrder,
         Null As PayModeO,
         cf.fk_mode_reglement AS PayModeI
  FROM        llx_societe AS s
    LEFT JOIN llx_commande_fournisseur          AS cf  ON cf.fk_soc = s.rowid
    LEFT JOIN llx_commande_fournisseur_dispatch AS cfd ON cf.rowid  = cfd.fk_commande
    LEFT JOIN llx_product_lot                   AS pl  ON pl.batch  = cfd.batch
    LEFT JOIN llx_reception                     AS r   ON r.rowid   = cfd.fk_reception
    LEFT JOIN llx_product                       AS p   ON p.rowid   = cfd.fk_product
  WHERE s.code_client IS NOT NULL  AND p.ref IS NOT NULL
)
ORDER BY Company,Product,Serial;
-- -- SELECT * FROM llx_productsIO ORDER BY Company,Product,Serial;
