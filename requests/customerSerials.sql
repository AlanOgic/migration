/* Serials of equipment currently owned (bought or loaned) by customer
*/
SELECT
  pb.Customer AS Customer,
  pb.Batch as Serial,
  SUM(pb.Batch_Qty) AS Quantity
FROM `llx_productsbalance` AS pb
WHERE pb.HasBatch =1 AND pb.Batch IS NOT NULL AND pb.Customer LIKE 'XD%'
GROUP BY Customer, Serial
HAVING SUM(pb.Batch_Qty) <> 0
ORDER BY Customer, Serial
