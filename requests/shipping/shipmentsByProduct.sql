-- Shipment by product, only for shipments generated from SO
SELECT
sh.ref as Shipment,
sh.date_valid as Date,
s.nom as Societe,
CASE
  WHEN p.accountancy_code_sell = 705000 THEN 'MSC'
  WHEN p.accountancy_code_sell = 705010 THEN 'RCP'
  WHEN p.accountancy_code_sell = 705020 THEN 'GWY'
  WHEN p.accountancy_code_sell = 705030 THEN 'CI0'
  WHEN p.accountancy_code_sell = 705032 THEN 'RIO'
  WHEN p.accountancy_code_sell = 705031 THEN 'NIO'
  WHEN p.accountancy_code_sell = 705040 THEN 'VP4'
  WHEN p.accountancy_code_sell = 705060 THEN 'ACC'
  WHEN p.accountancy_code_sell = 705070 THEN 'LIC'
  WHEN p.accountancy_code_sell = 705080 THEN 'DEV'
  WHEN p.accountancy_code_sell = 705050 THEN 'RES'
  WHEN p.accountancy_code_sell = 705090 THEN 'MSC'
  ELSE p.accountancy_code_sell
END AS PType,
p.ref as Product,
shd.qty As Qty,
p.cost_price as Cost,
cd.price AS SellPrice,
cd.price * shd.qty AS Amount
FROM  llx_commande as c
  LEFT JOIN llx_commandedet as cd on cd.fk_commande = c.rowid
  LEFT JOIN llx_expeditiondet as shd on  shd.fk_origin_line = cd.rowid
  LEFT JOIN llx_expedition as sh on sh.rowid = shd.fk_expedition
  LEFT JOIN llx_product as p on p.rowid = cd.fk_product
  LEFT JOIN llx_societe as s on s.rowid = c.fk_soc
WHERE sh.date_valid is not NULL
ORDER BY Shipment,PType,Product

-- Shipment by product type and date, only for shipments generated from SO
SELECT
  DATE_FORMAT(date(c.date_valid),"%y-%m") AS Month,
  CASE
    WHEN p.accountancy_code_sell = 705000 THEN 'MSC'
    WHEN p.accountancy_code_sell = 705010 THEN 'RCP'
    WHEN p.accountancy_code_sell = 705020 THEN 'GWY'
    WHEN p.accountancy_code_sell = 705030 THEN 'CI0'
    WHEN p.accountancy_code_sell = 705032 THEN 'RIO'
    WHEN p.accountancy_code_sell = 705031 THEN 'NIO'
    WHEN p.accountancy_code_sell = 705040 THEN 'VP4'
    WHEN p.accountancy_code_sell = 705060 THEN 'ACC'
    WHEN p.accountancy_code_sell = 705070 THEN 'LIC'
    WHEN p.accountancy_code_sell = 705080 THEN 'DEV'
    WHEN p.accountancy_code_sell = 705050 THEN 'RES'
    WHEN p.accountancy_code_sell = 705090 THEN 'MSC'
    ELSE p.accountancy_code_sell
  END AS Pcode,
  -- c.fk_mode_reglement AS Type, -- llx_c_paiement
  -- sh.ref   AS Debit,
  -- p.ref    AS Product,
  SUM(shd.qty) AS Qty
FROM  llx_commande as c
  LEFT JOIN llx_commandedet as cd on cd.fk_commande = c.rowid
  LEFT JOIN llx_expeditiondet as shd on  shd.fk_origin_line = cd.rowid
  LEFT JOIN llx_expedition as sh on sh.rowid = shd.fk_expedition
  LEFT JOIN llx_product as p on p.rowid = cd.fk_product
WHERE 1 = 1
GROUP BY Month,Pcode
-- and s.nom like "XD motion" -- Debug
