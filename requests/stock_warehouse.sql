/* Products according to warehouse
*/
SELECT p.ref AS Product,
       e.ref AS Warehouse,
       sp.reel AS Qty,
       p.stock AS TotQty,
       p.cost_price AS UnitCost,
       p.price AS UnitPrice,
       (sp.reel * p.cost_price) AS WareValue,
       (p.stock * p.cost_price) AS TotValue,
       (p.stock * p.price) AS ReselValue
FROM   llx_product  AS p
  LEFT JOIN llx_product_stock      AS sp  ON p.rowid   = sp.fk_product
  LEFT JOIN llx_entrepot           AS e   ON e.rowid   = sp.fk_entrepot
WHERE p.stock > 0
ORDER BY p.ref

/* Current stock value
*/
SELECT p.ref AS Product,
       p.stock AS Qty,
       COALESCE(p.cost_price,0) AS UnitCost,
       p.price AS UnitPrice,
       (p.stock * COALESCE(p.cost_price,0)) AS Value,
       (p.stock * COALESCE(p.price,0)) AS Reselling
FROM   llx_product  AS p
WHERE p.stock > 0
ORDER BY p.ref

/* Compute Stocks from Moves table
*/
SELECT
  p.ref AS Product,
  SUM(sm.value) AS StockVar,
  SUM(p.stock * COALESCE(p.cost_price,0)) AS AmountVar
FROM
  llx_stock_mouvement AS sm
  LEFT JOIN llx_product AS p ON p.rowid = sm.fk_product
WHERE sm.value IS NOT NULL
GROUP BY Product


/* Variation of stock per month and per product
*/
SELECT
  p.ref AS Product,
  DATE_FORMAT(date(sm.datem),"%y-%m")  AS Month,
  SUM(sm.value) AS StockVar,
  SUM(sm.value * COALESCE(p.cost_price,0)) AS AmountVar
FROM
  llx_stock_mouvement AS sm
  LEFT JOIN llx_product AS p ON p.rowid = sm.fk_product
WHERE date(sm.datem) BETWEEN '2021-6-1' AND '2021-6-30'
GROUP BY Month,Product
ORDER BY Month,Product

/* Variation of stock per month
*/
SELECT
  DATE_FORMAT(date(sm.datem),"%y-%m")  AS Month,
  SUM(sm.value) AS StockVar,
  SUM(sm.value * COALESCE(p.cost_price,0)) AS AmountVar
FROM
  llx_stock_mouvement AS sm
  LEFT JOIN llx_product AS p ON p.rowid = sm.fk_product
WHERE 1
GROUP BY Month
ORDER BY Month
