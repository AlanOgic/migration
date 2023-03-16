-- Replenishment is done through
--   + reception from external provider
--   - consumption from MO + production from MO (internal movement)
--   + stock corrections (internal or external -to be prohibited !!!)
SELECT DATE_FORMAT(date(sm.datem),'%y-%m')  AS Month,
 CASE WHEN p.accountancy_code_sell = 705000 THEN 'MSC'
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
 ELSE 'TBD'
 END AS Pcode,
 SUM(sm.value) AS Qty,
 p.ref AS Product,
 sm.origintype AS Origin
 FROM  llx_stock_mouvement as sm
 LEFT JOIN llx_product as p on p.rowid = sm.fk_product
 WHERE sm.datem IS NOT NULL
       AND sm.origintype IN ('reception','mo','')
       AND sm.fk_entrepot IN (1,5,7) -- entrepôts Raw, Shipping, Produits
 GROUP BY Month,Pcode,Product,Origin 
 ORDER BY Month,Pcode;
