/*
  Recherche des lignes de produits commandés
  * par PO de type stock
  * les paiements faits (en USD) par PO
  * les produits délivrés
  * les produits consommés
  * entre deux dates
  Notes:
  * order type:1,Stock;2,Stock only;3,Order only;4,RMA;5,Return;6,Transfert;7,Consumable;8,Investment;9,Other
  Sources:
  * https://wiki.dolibarr.org/index.php?title=Table_llx_element_element&mobileaction=toggle_view_desktop
*/
/*
TODO
* ADD Invoice Line Total
* CHECK sum of invoice total soould be the one in accounting
* CHECK DUPLICATES
*/
SELECT DISTINCT
  po.ref AS PO,
  SUBSTRING(ff.ref_supplier,1,10) AS FactACHMSE,
  SUBSTRING(ff.ref_supplier,11) AS Equipment,
  p.ref  AS Product,
  s.nom  AS Company,
  pod.qty AS QtyOrdered,
  rcpt.qty AS QtyReceived,
  pod.multicurrency_total_ht AS LineTotal,
  po.multicurrency_total_ht AS POTotal,
  ff.multicurrency_total_ht AS INVPaid,
  po.multicurrency_code AS Currency,
  po.multicurrency_tx AS Rate,
  rcpt.qty * pod.subprice * po.multicurrency_tx AS Rcpt_Value,
  stock.forsale AS ForSale,
  stock.bqc AS BQC,
  stock.fanco AS Fanco,
  stock.china AS China,
  stock.limbes AS Limbes,
  ff.ref AS InvoiceSuppl,
  ffd.qty AS InvoicedQty,
  ffd.qty * ffd.pu_ht * ff.multicurrency_tx AS InvoicedAmount,
  CONCAT('=HYPERLINK("https://dolibarr.cyanview.ovh/fourn/commande/card.php?id=',po.rowid,'","',po.ref,'")') AS POlink,
  CONCAT('=HYPERLINK("https://dolibarr.cyanview.ovh/fourn/facture/card.php?id=',ff.rowid,'","',ff.ref,'")') AS  SIlink
  -- po.delivered AS Delivered,
  -- mo.consummed AS Consumed
FROM llx_commande_fournisseur AS po
  LEFT JOIN llx_commande_fournisseur_extrafields AS poef ON poef.fk_object = po.rowid
  LEFT JOIN llx_societe AS s ON s.rowid = po.fk_soc
  LEFT JOIN llx_commande_fournisseurdet AS pod ON pod.fk_commande = po.rowid
  LEFT JOIN llx_product AS p ON p.rowid = pod.fk_product
  LEFT JOIN llx_commande_fournisseur_dispatch AS rcpt ON rcpt.fk_commandefourndet = pod.rowid AND rcpt.datec < '2022-07-04'
  LEFT JOIN
    (
      SELECT
        sm.fk_product AS product,
        SUM(CASE WHEN sm.fk_entrepot IN (1,5,7) THEN sm.value ELSE 0 END) AS ForSale,
        SUM(CASE WHEN sm.fk_entrepot IN (3) THEN sm.value ELSE 0 END)  AS BQC,
        SUM(CASE WHEN sm.fk_entrepot IN (11) THEN sm.value ELSE 0 END) AS Fanco,
        SUM(CASE WHEN sm.fk_entrepot IN (12) THEN sm.value ELSE 0 END) AS China,
        SUM(CASE WHEN sm.fk_entrepot IN (2,4,6,7,8,9,10,13,14,15) THEN sm.value ELSE 0 END) AS Limbes
      FROM
        llx_stock_mouvement AS sm
      WHERE sm.datem < '2022-07-04'
      GROUP BY sm.fk_product
    ) AS stock ON stock.product = p.rowid
  LEFT JOIN llx_element_element AS ee ON ee.sourcetype = 'order_supplier' AND ee.fk_source = po.rowid AND ee.targettype = 'invoice_supplier'
  LEFT JOIN llx_facture_fourn AS ff ON ff.rowid = ee.fk_target
  LEFT JOIN llx_facture_fourn_det AS ffd ON ffd.fk_facture_fourn = ff.rowid AND ffd.fk_product = p.rowid
WHERE poef.type = 1 AND ff.datef BETWEEN '2021-07-01' AND '2022-07-04' AND p.ref IS NOT NULL AND ff.ref_supplier LIKE "22ACHMSE%"
ORDER BY FactACHMSE
