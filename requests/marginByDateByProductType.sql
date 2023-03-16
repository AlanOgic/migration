/* Stock, Margin and CA per month ans per product code
*/
SELECT
  DATE_FORMAT(date(f.datef),"%y-%m")  AS Month,
  CASE
    WHEN p.accountancy_code_sell = "705000" THEN "X_MSC"
    WHEN p.accountancy_code_sell = "705010" THEN "1_RCP"
    WHEN p.accountancy_code_sell = "705020" THEN "2_GWY"
    WHEN p.accountancy_code_sell = "705030" THEN "3_CI0"
    WHEN p.accountancy_code_sell = "705032" THEN "4_RIO"
    WHEN p.accountancy_code_sell = "705031" THEN "5_NIO"
    WHEN p.accountancy_code_sell = "705040" THEN "6_VP4"
    WHEN p.accountancy_code_sell = "705060" THEN "7_ACC"
    WHEN p.accountancy_code_sell = "705070" THEN "8_LIC"
    WHEN p.accountancy_code_sell = "705080" THEN "9_DEV"
    WHEN p.accountancy_code_sell = "705050" THEN "G_RES"
    WHEN p.accountancy_code_sell = "705090" THEN "X_MSC"
    ELSE p.accountancy_code_sell
  END AS Pcode,
  SUM(fd.qty * p.price) AS Amount,
  SUM(fd.qty) AS Qty,
  SUM(fd.qty * COALESCE(p.cost_price,0)) AS Cost,
  SUM(fd.qty * (p.price - COALESCE(p.cost_price,0))) AS Margin
FROM
  llx_facturedet AS fd
  LEFT JOIN llx_facture AS f ON fd.fk_facture = f.rowid
  LEFT JOIN llx_product AS p ON fd.fk_product = p.rowid
  LEFT JOIN llx_societe AS s ON f.fk_soc  = s.rowid
WHERE 1
GROUP BY Month,Pcode
ORDER BY Month,Pcode
