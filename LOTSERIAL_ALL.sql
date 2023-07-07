CREATE OR REPLACE VIEW all_sn AS
SELECT 
    pl.batch,
    pl.entity,
    p.ref
FROM llx_product_lot AS pl
RIGHT JOIN llx_product AS p ON pl.fk_product = p.rowid
ORDER BY pl.batch ASC
SELECT * FROM all_sn;