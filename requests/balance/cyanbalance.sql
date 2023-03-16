-- Provides readable and sorted information on "llx_productsBalance" table for REST API
SELECT pb.Customer AS CustomerRef, pb.DDate AS DDate, pb.Type AS TType,pb.OOrder AS OOrder,
pb.Debit AS Debit, pb.CreditRcpt AS CreditRcpt, pb.CreditInv AS CreditInv,
pb.Product AS Product,pb.Qty AS Qty, pb.Batch AS Batch, pb.Batch_Qty AS Batch_Qty,
pb.CustomerId AS CustomerId, pb.HasBatch AS HasBatch,
p.code AS PaymCode,c.ref AS OrderRef, e.ref AS ShipmentRef,r.ref AS RcptRef,
f.ref AS InvoiceRef,pr.ref AS ProductRef
FROM llx_productsBalance AS pb
LEFT JOIN llx_c_paiement AS p ON p.id = pb.Type
LEFT JOIN llx_commande AS c ON c.rowid = pb.OOrder
LEFT JOIN llx_expedition AS e ON e.rowid = pb.Debit
LEFT JOIN llx_reception AS r ON r.rowid = pb.CreditRcpt
LEFT JOIN llx_facture AS f ON f.rowid = pb.CreditInv
LEFT JOIN llx_product AS pr ON pr.rowid = pb.Product
WHERE 1 = 1
ORDER BY CustomerRef, DDate, TType, HasBatch, Product
