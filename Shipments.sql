CREATE OR REPLACE VIEW ORDRSHIP AS
SELECT
    s.ref AS "ref",
    p.produits AS "produits"
FROM llx_commande AS c 
    LEFT JOIN llx_commandedet AS cd ON cd.fk_commande = c.rowid 
    LEFT JOIN llx_expeditiondet AS shd ON shd.fk_origin_line = cd.rowid 
    LEFT JOIN llx_expedition AS sh ON sh.rowid = shd.fk_expedition 
    LEFT JOIN llx_product AS p ON p.rowid = cd.fk_product 
    LEFT JOIN llx_societe AS s ON s.rowid = c.fk_soc 
WHERE sh.date_valid is not NULL;
SELECT * FROM ORDRSHIP;