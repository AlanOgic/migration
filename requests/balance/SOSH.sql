SELECT
  s.nom AS Customer,
  c.date_valid AS DDate,
  c.fk_mode_reglement AS Type, -- llx_c_paiement
  c.rowid AS OOrder,
  c.ref AS soref,
  sh.ref AS shref,
  sh.rowid AS Debit,
  p.ref AS Product,
  CASE p.tobatch WHEN 0 THEN shd.qty ELSE shdb.qty END AS Qty,
  -- (shdb.qty IS NOT NULL) + shd.qty*(not p.tobatch) AS Qty,
  shdb.batch AS Batch,
  shdb.qty AS Batch_Qty,
  s.rowid AS CustomerId,
  p.tobatch AS HasBatch
FROM llx_societe as s
  LEFT JOIN llx_commande as c on c.fk_soc = s.rowid
  LEFT JOIN llx_commandedet as cd on cd.fk_commande = c.rowid
  LEFT JOIN llx_expeditiondet as shd on  shd.fk_origin_line = cd.rowid
  LEFT JOIN llx_expedition as sh on sh.rowid = shd.fk_expedition
  -- LEFT JOIN llx_element_element as ee on sh.rowid = ee.fk_target AND ee.targettype = "shipping" AND ee.sourcetype = "commande"
  LEFT JOIN llx_expeditiondet_batch as shdb on shdb.fk_expeditiondet = shd.rowid
  LEFT JOIN llx_product as p on p.rowid = cd.fk_product
WHERE sh.rowid IS NOT NULL AND c.date_valid IS NOT NULL
UNION(
  SELECT
    s.nom AS Customer,
    f.date_valid AS DDate,
    c.fk_mode_reglement AS Type, -- llx_c_paiement
    c.rowid  AS OOrder,
    NULL AS Debit,
    NULL AS  CreditRcpt,
    f.rowid AS CreditInv,
    p.rowid AS Product,
    (fd.qty * -1) AS Qty,
    NULL AS Batch,
    NULL AS Batch_Qty,
    s.rowid AS CustomerId,
    p.tobatch AS HasBatch
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