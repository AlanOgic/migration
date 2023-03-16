SELECT
DATE_FORMAT(c.date_valid,'%y-%m-%d') AS VDate,
c.rowid AS "SO",
c.fk_statut AS "SOStatut",
f.rowid AS "INV",
p.libelle AS "Reglement",
CONCAT('',e.tracking_number,'') AS "Tracking",
e.rowid AS "Shipment",
e.fk_statut AS "SHstatut",
c.ref_client AS "CustRef",
c.multicurrency_total_ht AS "Amount",
c.multicurrency_code AS "Currency",
s.rowid AS "Customer",
sm.libelle AS "Carrier",
c.note_private AS "Note"
FROM llx_expedition AS e 
    LEFT JOIN llx_element_element AS ee ON ee.targettype = 'shipping' AND e.rowid = ee.fk_target 
    LEFT JOIN llx_commande AS c ON ee.sourcetype = 'commande' AND c.rowid = ee.fk_source 
    LEFT JOIN llx_commande_extrafields AS ce ON ce.fk_object = c.rowid 
    LEFT JOIN llx_c_paiement AS p ON p.id = c.fk_mode_reglement 
    LEFT JOIN llx_societe AS s ON s.rowid = c.fk_soc 
    LEFT JOIN llx_c_shipment_mode AS sm ON sm.rowid = e.fk_shipping_method 
    LEFT JOIN llx_element_element AS eebis ON c.rowid = eebis.fk_source AND eebis.sourcetype = 'commande' AND eebis.targettype = 'facture' 
    LEFT JOIN llx_facture AS f ON f.rowid = eebis.fk_target 
WHERE c.rowid IS NOT NULL ORDER BY VDate DESC