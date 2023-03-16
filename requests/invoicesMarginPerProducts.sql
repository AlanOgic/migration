
/* Invoices and margin
*/
SELECT f.rowid AS Reference,f.datef	AS Date,f.total_ht	AS Total_HT,
s.rowid	AS Client ,c.code	AS Pays, p.rowid	AS Ref ,p.accountancy_code_sell	AS Code,
fd.qty	AS Qty,p.cost_price	AS Cost,fd.total_ht	AS Total,f.fk_statut as Status
FROM llx_societe as s
  LEFT JOIN llx_categorie_societe as cs ON s.rowid = cs.fk_soc
  LEFT JOIN llx_c_country as c on s.fk_pays = c.rowid, llx_facture as f
  LEFT JOIN llx_projet as pj ON f.fk_projet = pj.rowid
  LEFT JOIN llx_user as uc ON f.fk_user_author = uc.rowid
  LEFT JOIN llx_user as uv ON f.fk_user_valid = uv.rowid
  LEFT JOIN llx_facture_extrafields as extra ON f.rowid = extra.fk_object , llx_facturedet as fd
  LEFT JOIN llx_facturedet_extrafields as extra2 on fd.rowid = extra2.fk_object
  LEFT JOIN llx_product as p on (fd.fk_product = p.rowid)
  LEFT JOIN llx_product_extrafields as extra3 ON p.rowid = extra3.fk_object
WHERE f.fk_soc = s.rowid AND f.rowid = fd.fk_facture AND f.entity IN (1) ORDER BY f.rowid
