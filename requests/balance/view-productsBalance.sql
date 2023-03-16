-- SQL request giving the balance between shipped products, returned products and invoiced products
-- SHIPMENT: the equipment really having left Cyanview to a customer
CREATE VIEW llx_productsBalance AS
SELECT
  s.nom      AS Customer,
  c.date_valid AS DDate,
  c.fk_mode_reglement AS Type, -- llx_c_paiement
  c.rowid    AS OOrder,
  sh.rowid   AS Debit,
  NULL       AS CreditRcpt,
  NULL       AS CreditInv,
  p.rowid    AS Product,
  CASE p.tobatch WHEN 0 THEN shd.qty ELSE shdb.qty END AS Qty,
  -- (shdb.qty IS NOT NULL) + shd.qty*(not p.tobatch) AS Qty,
  shdb.batch AS Batch,
  shdb.qty   AS Batch_Qty,
  s.rowid    AS CustomerId,
  p.tobatch  AS HasBatch

FROM llx_societe as s
  LEFT JOIN llx_commande as c on c.fk_soc = s.rowid
  LEFT JOIN llx_commandedet as cd on cd.fk_commande = c.rowid

  LEFT JOIN llx_expeditiondet as shd on  shd.fk_origin_line = cd.rowid
  LEFT JOIN llx_expedition as sh on sh.rowid = shd.fk_expedition
  -- LEFT JOIN llx_element_element as ee on sh.rowid = ee.fk_target AND ee.targettype = "shipping" AND ee.sourcetype = "commande"
  LEFT JOIN llx_expeditiondet_batch as shdb on shdb.fk_expeditiondet = shd.rowid
  LEFT JOIN llx_product as p on p.rowid = cd.fk_product
WHERE sh.rowid IS NOT NULL AND c.date_valid IS NOT NULL
-- and s.nom like "XD motion" -- Debug

/* RECEPTION: the equipment returned to Cyanview from a customer*/
UNION(
  SELECT
    s.nom   AS Customer,
    cf.date_valid AS DDate,
    NULL  AS Type,
    NULL  AS OOrder, -- even if cf.row id is available, the value is considerered as a SO by Mylist
    NULL  AS Debit,
    r.rowid   AS CreditRcpt,
    NULL   AS CreditInv,
    p.rowid   AS Product,
    CASE p.tobatch WHEN 0 THEN cfd.qty * -1 ELSE cfdb.qty * -1 END AS Qty,
    -- (cfdb.qty IS NOT NULL)*-1 + cfd.qty*(not p.tobatch)*-1 AS Qty,
    cfdb.batch AS Batch,
    (cfdb.qty * -1)   AS Batch_Qty,
    s.rowid    AS CustomerId,
    p.tobatch  AS HasBatch
  FROM llx_societe as s
    LEFT JOIN llx_commande_fournisseur as cf on cf.fk_soc = s.rowid
    LEFT JOIN llx_commande_fournisseurdet as cfd on cfd.fk_commande = cf.rowid
    LEFT JOIN llx_commande_fournisseur_dispatch as cfdb on cfdb.fk_commandefourndet = cfd.rowid
    LEFT JOIN llx_reception as r on cfdb.fk_reception = r.rowid
    -- associer les factures liées aux commandes ou aux shipping (les factures liées aux propales ne font pas l'objet d'envois)
    LEFT JOIN llx_product as p on p.rowid = cfd.fk_product
    -- associer les lignes de shipment de l'expédition détaillée, contenus dans la commande associée
  WHERE r.ref IS NOT NULL AND cf.date_valid IS NOT NULL
  -- and s.nom like "XD motion" -- Debug
)
/*INVOICE from orders and shipments: the equipment returned to Cyanview from a customer
  note: invoice with shipment origin have always the command associated to the shipment  as origin **/
UNION(
  SELECT
    s.nom  AS Customer,
    f.date_valid AS DDate,
    c.fk_mode_reglement AS Type, -- llx_c_paiement
    c.rowid  AS OOrder,
    NULL   AS Debit,
    NULL  AS  CreditRcpt,
    f.rowid  AS CreditInv,
    p.rowid  AS Product,
    (fd.qty * -1) AS Qty,
    NULL   AS Batch,
    NULL   AS Batch_Qty,
    s.rowid    AS CustomerId,
    p.tobatch  AS HasBatch
  FROM llx_societe as s
    LEFT JOIN llx_commande as c on c.fk_soc = s.rowid
    LEFT JOIN llx_commandedet as cd on cd.fk_commande = c.rowid
    -- associer les factures liées aux commandes ou aux shipping (les factures liées aux propales ne font pas l'objet d'envois)
    LEFT JOIN llx_element_element as eebis on eebis.targettype = "facture" AND
        eebis.fk_source=c.rowid AND eebis.sourcetype="commande"
    LEFT JOIN llx_facture as f ON f.rowid = eebis.fk_target
    LEFT JOIN llx_facturedet as fd ON fd.fk_facture = f.rowid
    LEFT JOIN llx_product as p on p.rowid = fd.fk_product
    -- associer les lignes de shipment de l'expédition détaillée, contenus dans la commande associée
  WHERE f.rowid IS NOT NULL and f.date_valid IS NOT NULL
  -- and s.nom like "XD motion" -- Debug

)
ORDER BY Customer,OOrder,Product


/*
SELECT pb.Customer AS CustomerRef, pb.DDate AS DDate, pb.Type AS Type,pb.OOrder AS OOrder,pb.Debit AS Debit, pb.CreditRcpt AS CreditRcpt, pb.CreditInv AS CreditInv, pb.Product AS Product,pb.Qty AS Qty, pb.Batch AS Batch, pb.Batch_Qty AS Batch_Qty,
pb.CustomerId AS CustomerId, pb.HasBatch AS HasBatch,
p.code AS PaymCode,c.ref AS OrderRef, e.ref AS ShipmentRef,r.ref AS RcptRef,
f.ref AS InvoiceRef,pr.ref AS ProductRef
FROM llx_productsBalance AS pb
LEFT JOIN llx_c_paiement AS p ON p.id = pb.Type
LEFT JOIN llx_commande AS c ON c.rowid = pb.OOrder
LEFT JOIN llx_expedition AS e ON e.rowid = pb.Debit
LEFT JOIN llx_reception AS r ON r.rowid = pb.CreditRcpt
LEFT JOIN llx_facture AS f ON f.rowid = pb.CreditInv
LEFT JOIN llx_product AS pr ON pr.rowid = pb.Product
WHERE 1 = 1


*/
