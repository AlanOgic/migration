/*
Currency	Customer
Order Reference
Status   Invoice Status   Delivery Status
Delivery Date 	Effective Date	Order Date
Total	 Untaxed Amount
Order Lines	Order Lines/Cost	Order Lines/Unit Price	Order Lines/Total	Order Lines/Subtotal
Order Lines/Quantity To Invoice	Order Lines/Quantity	Order Lines/Qty To Deliver
*/
SELECT
  cd.rowid AS "External ID",
  cd.multicurrency_code AS "Currency",
  c.ref AS "Order Reference",
  s.nom AS "Customer",
  -- Status
  "sales order" AS Status,
  CASE
    WHEN  THEN "Fully Invoiced"
    WHEN  THEN "To Invoice"
    WHEN  THEN "Nothing to Invoice"
  END AS "Invoice Status",
  CASE
    WHEN THEN "Fully Delivered"
    WHEN THEN "Not Delivered"
    WHEN THEN "Partially Delivered"
  END AS "Delivery Status" ,
  -- Dates
  c.date_valid AS "Delivery Date",
  c.date_valid AS "Effective Date",
  c.date_valid AS "Order Date",
  -- Total Amounts
  c.total_ht AS  Total,
  c.total_ht AS  "Untaxed Amount",
  -- Amounts in currency !!!
  c.multicurrency_tx AS Rate, -- To be checked
  c.multicurrency_total_ht AS "Total In Currency", -- To be checked
  -- Order Lines
  CONCAT(c.ref," - [",p.ref,"] ",p.desription) AS "Order Lines"

FROM
  llx_commande AS c
  LEFT JOIN llx_commandedet AS cd ON c.rowid = cd.fk_commande
  LEFT JOIN llx_societe AS s ON s.rowid = c.fk_soc
  LEFT JOIN llx_produit AS p ON p.rowid = cd.fk_product

WHERE 1
