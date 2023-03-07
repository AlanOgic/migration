  /* Original Odoo EXIM (export for import) of orders
  -- Orders fields
  External ID                : sorder0001
  name                       : S00097	
  partner name               : 3G Wireless LLC
  parner external id         : compan0001
  date_order                 : 2023-01-09 09:54:51	
  commitment_date            : 2023-01-09 09:54:51
  pricelist_id/name          : USD Reseller
  fiscal_position_id/name	   : Régime Extra-Communautaire
  payment_term_id/name       : 30 Days 	
  -- Line orders fields
  order_line/name            : [FURN_6666] Acoustic Bloc Screens
  order_line                 : S00097 - [FURN_6666] Acoustic Bloc Screens
  order_line/discount        : 92.31	
  order_line/price_unit      : 10,400.00
  order_line/product_uom_qty : 1.00	
  order_line/is_expense	     : FALSE
  */
  CREATE OR REPLACE VIEW c1a_sorder AS 
  SELECT
    /* Order fields */
    CONCAT("sorder",LPAD(c.rowid,4,0)) AS "External ID",
    c.ref AS "name",
    -- s.nom AS "partner name", -- dont use it as a primary key
    -- first_line.ref AS "name", --same extID for lines
    -- first_line.dateorder AS "date_order", --same date for lines
    -- Dates
    CONCAT("compan",LPAD(c.fk_soc,4,0)) AS "partner External ID",
    DATE_FORMAT(date(c.date_commande),'%Y-%m-%d') AS "date_order",
    DATE_FORMAT(date(c.date_creation),'%Y-%m-%d') AS "date_creation",
    st.id AS "statut_external_id",
    st.name AS "status_name",
    CASE
      WHEN st.id = 0 THEN "Draft"
      WHEN st.id = 1 THEN "Sent"
      WHEN st.id = 2 THEN "Sale"
      WHEN st.id = 3 THEN "Done"
    END AS "state",
    c.total_ht AS "total_HT",
    c.note_public AS "public note", 
    c.ref_client AS "client_order_ref",
    c.note_private AS "private note", 
  DATE_FORMAT(date(c.date_livraison),'%Y-%m-%d') AS "commitment_date"
    /* order lines with a second order import
    CONCAT("[",p.label,"] ",p.ref) AS "order_line/product",
    CONCAT(c.ref," - [",p.label,"] ",p.ref) AS "order_line/description",
    cd.remise_percent AS "order_line/discount",
    cd.qty AS "order_line/product_uom_qty",
    cd.multicurrency_subprice AS "order_line/price_unit",
    IF(ISNULL(cd.fk_product),"TRUE","FALSE") AS "order_line/is_expense"*/
  FROM 
    llx_commande AS c
    LEFT JOIN status AS st ON st.id = c.fk_statut
    -- LEFT JOIN llx_commandedet AS cd ON cd.fk_commande = c.rowid
    -- LEFT JOIN llx_product     AS p ON p.rowid = cd.fk_product
    -- LEFT JOIN llx_societe     AS s ON s.rowid = c.fk_soc
  WHERE 1=1;
  SELECT * FROM c1a_sorder;
