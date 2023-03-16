-- SQL REQUESTS ON DOLIBARR CYANVIEW DATABASE
-- INVOICE LINE DETAILS A
-- Getting details (lines) of invoice with
-- + Company_name, invoice reference, product reference, total_ht, quantity of product, per unit buying price of product,
-- + per line cost of product, per line margin
SELECT s.nom ,f.ref, f.datef, p.ref, fd.total_ht, fd.qty, fd.buy_price_ht, fd.qty * fd.buy_price_ht AS cost, fd.total_ht - (fd.qty * fd.buy_price_ht) AS margin
FROM
  llx_facturedet AS fd
  LEFT JOIN llx_facture AS f ON fd.fk_facture = f.rowid
  LEFT JOIN llx_product AS p ON fd.fk_product = p.rowid
  LEFT JOIN llx_societe AS s ON f.fk_soc  = s.rowid
WHERE f.datef BETWEEN '2020/01/01' AND '2021/01/01'

-- INVOICE LINE AGGREGATES PER CUSTOMER
-- Getting aggregates of invoices list for customers
SELECT s.nom AS Company, SUM(fd.total_ht) AS Total, SUM(fd.qty) AS Units, SUM(fd.qty * fd.buy_price_ht) AS Cost, SUM(fd.total_ht - (fd.qty * fd.buy_price_ht)) AS Margin
FROM
  llx_facturedet AS fd
  LEFT JOIN llx_facture AS f ON fd.fk_facture = f.rowid
  LEFT JOIN llx_product AS p ON fd.fk_product = p.rowid
  LEFT JOIN llx_societe AS s ON f.fk_soc  = s.rowid
WHERE f.datef BETWEEN '2020/01/01' AND '2021/01/01'
GROUP BY s.nom

-- INVOICE LINE AGGREGATES PER PRODUCT
-- Getting aggregates of invoices list for products
SELECT p.ref AS Company, SUM(fd.total_ht) AS Total , SUM(fd.qty) AS Units,SUM(fd.qty * fd.buy_price_ht) AS Cost, SUM(fd.total_ht - (fd.qty * fd.buy_price_ht)) AS Margin
FROM
  llx_facturedet AS fd
  LEFT JOIN llx_facture AS f ON fd.fk_facture = f.rowid
  LEFT JOIN llx_product AS p ON fd.fk_product = p.rowid
  LEFT JOIN llx_societe AS s ON f.fk_soc  = s.rowid
WHERE f.datef BETWEEN '2020/01/01' AND '2021/01/01'
GROUP BY p.ref

-- INVOICE LINE AGGREGATES PER INVOICE
-- Getting invoice aggregate from lines of invoice (check purposes) 
SELECT f.ref, MAX(s.nom) AS Company, SUM(fd.total_ht) AS Total , SUM(fd.qty) AS Units,SUM(fd.qty * fd.buy_price_ht) AS Cost, SUM(fd.total_ht - (fd.qty * fd.buy_price_ht)) AS Margin
FROM
  llx_facturedet AS fd
  LEFT JOIN llx_facture AS f ON fd.fk_facture = f.rowid
  LEFT JOIN llx_product AS p ON fd.fk_product = p.rowid
  LEFT JOIN llx_societe AS s ON f.fk_soc  = s.rowid
WHERE f.datef BETWEEN '2020/01/01' AND '2021/01/01'
GROUP BY f.ref
