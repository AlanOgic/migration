

FROM llx_commande as c 
    LEFT JOIN llx_commandedet as cd on cd.fk_commande = c.rowid 
    LEFT JOIN llx_expeditiondet as shd on shd.fk_origin_line = cd.rowid 
    LEFT JOIN llx_expedition as sh on sh.rowid = shd.fk_expedition 
    LEFT JOIN llx_product as p on p.rowid = cd.fk_product 
    LEFT JOIN llx_societe as s on s.rowid = c.fk_soc 
WHERE sh.date_valid is not NULL