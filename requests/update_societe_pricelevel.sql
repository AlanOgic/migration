-- Set Price level of US companies
UPDATE llx_societe
SET price_level = 1
WHERE fk_pays = 11;
-- Set Price level of non US companies
UPDATE llx_societe
SET price_level = 2
WHERE NOT fk_pays = 11; 
