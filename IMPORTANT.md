Source : https://pastebin.com/CFWTXHbw
In the PG_SQL to CREATE the table : sales order line
COMMENT ON CONSTRAINT sale_order_line_accountable_required_fields ON sale_order_line IS 'CHECK(display_type IS NOT NULL OR (product_id IS NOT NULL AND product_uom IS NOT NULL))';
COMMENT ON CONSTRAINT sale_order_line_non_accountable_null_fields ON sale_order_line IS 'CHECK(display_type IS NULL OR (product_id IS NULL AND price_unit = 0 AND product_uom_qty = 0 AND product_uom IS NULL AND customer_lead = 0))';`

BEFORE Import Sale Order Lines, (or both SO & SOLines at once):

1. To import directly with status as 'sale orders' (no 'quote' step)
Activate : dev mode
go to : settings -> technical -> Actions -> user-defined defaults
create : Status(sale.order) = "sale"

2. Required fields SO 
(model:field_name = Field Label)
sale.order:Company_id = Company
sale.order:create_date = Creation Date
sale.order:name = Order Reference
sale.order:partner_id = Customer
sale.order:state = Status

3. Required fields Sale Order lines
(model:field_name = Field Label)
sale.order.line:customer_lead = Lead Time
sale.order.line:name = Description
sale.order.line:order_id = Order Reference
sale.order.line:price_unit = Unit Price
sale.order.line:product_uom_qty = Quantity

4. NON NULL fields TODO
display_type IS NULL   --display type is Section or Note, I guess if it is null = lines with product
OR
product_id IS NULL  --product_id is Product Variant, non importable 
AND price_unit = 0 
AND product_uom_qty = 0 
AND product_uom IS NULL 
AND customer_lead = 0
