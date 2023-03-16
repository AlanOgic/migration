-- CHECK reference is in "Products" entrepôt
SELECT e.rowid AS Warehouse_id, e.ref AS Warehouse, p.rowid AS Product_id, p.ref AS Product, pb.batch AS Batch, pb.qty AS Quantity
FROM llx_product_batch AS pb
LEFT JOIN llx_product_stock AS ps ON ps.rowid = pb.fk_product_stock
LEFT JOIN llx_product AS p ON p.rowid = ps.fk_product
LEFT JOIN llx_entrepot AS e ON e.rowid = ps.fk_entrepot
WHERE pb.batch = "ZZ-FAKE-1" AND e.rowid = 7

-- API
{ "product_id": 349, "warehouse_id": 7, "qty": 1, "lot": "FAKE-2", "movementcode": "APITEST", "movementlabel": "Test API 1 ", "price": 0 }
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'DOLAPIKEY: FTP3Mt3XBac6f2nNLL2mgo3gz847i1MN' -d '{ "product_id": 349, "warehouse_id": 7, "qty": 1, "lot": "FAKE-2", "movementcode": "APITEST", "movementlabel": "Test API 1 ", "price": 0 }' 'https://dolibarr.cyanview.ovh/api/index.php/stockmovements'
https://dolibarr.cyanview.ovh/api/index.php/stockmovements
